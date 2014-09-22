#include "FiveWin.ch"

#define LTGRAY_BRUSH        1
#define RT_BITMAP           2

#define OPAQUE              2
#define TRANSPARENT         1

#define COLOR_BTNFACE      15
#define COLOR_BTNSHADOW    16
#define COLOR_BTNHIGHLIGHT 20

#define NO_FOCUSWIDTH      25
#define GWL_STYLE         -16

#define TME_LEAVE           2
#define WM_MOUSELEAVE     675

#define DT_TOP              0
#define DT_LEFT             0
#define DT_CENTER           1
#define DT_RIGHT            2
#define DT_VCENTER          4
#define DT_BOTTOM           8
#define DT_WORDBREAK       16
#define DT_SINGLELINE      32
#define DT_CALCRECT      1024

#define BTN_UP              1
#define BTN_DOWN            2
#define BTN_DISABLE         3
#define BTN_OVERMOUSE       4

#define LAYOUT_CENTER  0
#define LAYOUT_TOP     1
#define LAYOUT_LEFT    2
#define LAYOUT_BOTTOM  3
#define LAYOUT_RIGHT   4

#define DST_BITMAP      4
#define DSS_UNION      16
#define DSS_DISABLED   32
#define DSS_MONO      128

#define SRCCOPY      0x00CC0020

#define WM_SYSCHAR    262  // 0x0106

#define NULL_BRUSH      5

#define WS_EX_CLIENTEDGE  0x0200

#define GWL_EXSTYLE          -20

#define SWP_NOSIZE        0x0001
#define SWP_NOMOVE        0x0002
#define SWP_NOZORDER      0x0004
#define SWP_FRAMECHANGED  0x0020

static aLayouts := { "TOP", "LEFT", "BOTTOM", "RIGHT" }

//----------------------------------------------------------------------------//

CLASS TBtnBmp FROM TControl

   DATA   bAction
   DATA   cAction   // A string description of the action
   DATA   lPressed, lAdjust, lGroup AS LOGICAL
   DATA   lWorking, lBtnUp, lBtnDown
   DATA   lBoxSelect
   DATA   hBitmap1, hPalette1
   DATA   hBitmap2, hPalette2
   DATA   hBitmap3, hPalette3
   DATA   hBitmap4, hPalette4
   DATA   hBmp  // the bitmap currently being painted
   DATA   nBtn  // the bitmap order currently being painted
   DATA   hRgn
   DATA   cResName1, cResName2, cResName3, cResName4
   DATA   cBmpFile1, cBmpFile2, cBmpFile3, cBmpFile4
   DATA   lProcessing AS LOGICAL INIT .F.
   DATA   lBorder AS LOGICAL INIT .T.
   DATA   lRound AS LOGICAL INIT .T.
   DATA   lEllipse AS LOGICAL INIT .F.
   DATA   lBmpTransparent AS LOGICAL INIT .t.

   DATA   oPopup
   DATA   nLayout
   DATA   lMOver // mouse is over it
   DATA   bClrGrad
   DATA   l2007   INIT .F.
   DATA   l2010   INIT .F.
   DATA   lBarBtn INIT .F.
   DATA   aAlpha
   DATA   bAlphaLevel
   DATA   hAlphaLevel
   DATA   lDisColor INIT .T.
   DATA   nClrTextDis


   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight,;
               cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
               cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
               l2007, cResName4, cBmpFile4, lTransparent, cToolTip,;
               lRound, bGradColors, lPixel, lDesign ) CONSTRUCTOR

   METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cMsg, bAction, lGroup, oBar, lAdjust, bWhen,;
                  cToolTip, lPressed, bDrop, cAction, nPos,;
                  cResName3, cBmpFile3, lBorder, cLayout, cResName4, cBmpFile4 ) CONSTRUCTOR

   METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2,;
                    cMsg, bAction, oBar, lAdjust, bWhen, lUpdate,;
                    cToolTip, cPrompt, oFont, cResName3,;
                    cBmpFile3, lBorder, cLayout, cResName4, cBmpFile4, lTransparent,;
                    lRound, bGradColors ) CONSTRUCTOR

   METHOD Click()


   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Disable() INLINE ::Super:Disable(), ::Refresh()
   METHOD Enable()  INLINE ::Super:Enable(), ::Refresh()

   METHOD End() INLINE ::Destroy()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD FreeBitmaps()

   METHOD GetBmp()  // select the bitmap handle to paint

   METHOD GoUp() INLINE ::lPressed := ::lBtnDown := .F.,;
                        ::Refresh()

   METHOD GoDown() INLINE ::lPressed := ::lBtnDown := .T.,;
                        ::Refresh()

   METHOD ResetBorder() INLINE ::lBorder := .F.,;
                        ::Refresh()

   METHOD cGenPRG()
   METHOD LButtonDown( nRow, nCol )
   METHOD LButtonUp( nRow, nCol )
   METHOD LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2, cResName3, cBmpFile3, cResName4, cBmpFile4 )

   METHOD GotFocus( hCtlLost )

   METHOD Initiate( hDlg )

   METHOD KeyChar( nKey, nFlags )
   METHOD KeyDown( nKey, nFlags )

   METHOD LostFocus()

   METHOD Paint()

   METHOD PaintBitmap()

   METHOD PaintBorder()

   METHOD PaintCaption()

   METHOD PaintPopupSection()

   METHOD PaintBackGroundAs20072010()

   METHOD PaintBackGroundStandard()

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Destroy()

   METHOD DrawEllipse( hDC, nRGBColor, n )

   METHOD DrawFocusEllipse( hDC )

   METHOD SetFile( cBmpUpFile, cBmpDownFile )

   METHOD Toggle() INLINE ::lBtnDown := ! ::lBtnDown,;
                          ::lPressed := ::lBtnDown,;
                          ::Refresh()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD HasAlpha( hBitmap, nBtn ) INLINE ::aAlpha[ MAX( MAX( MIN( nBtn,1 ), MIN( nBtn, 4 ) ), 0 ) ] := HasAlpha( hBitmap )

   METHOD MouseLeave( nRow, nCol, nFlags )

   METHOD ShowPopup()

   METHOD SetColor( nClrText, nClrPane )

   METHOD nAlphaLevel( nLevel ) SETGET

   METHOD aGrad() INLINE If( ::bClrGrad != nil, Eval( ::bClrGrad, ( ::lMOver .OR. ::lPressed ) ),;
                         If( ::oWnd:bClrGrad != nil, Eval( ::oWnd:bClrGrad, ::lMOver ), ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight,;
            cResName1, cResName2, cBmpFile1, cBmpFile2,;
            bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
            cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
            l2007, cResName4, cBmpFile4, lTransparent, cToolTip, lRound,;
            bGradColors, lPixel, lDesign )  CLASS TBtnBmp

   DEFAULT cMsg := " ", nTop := 0, nLeft := 0, lAdjust := .F.,;
           lUpdate := .F., oWnd := GetWndDefault(), lBorder := .T.,;
           l2007 := .F., cLayout := "TOP", lTransparent := .F., lRound := .T.,;
           lPixel := .T., lDesign := .F.

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,; // WS_CLIPSIBLINGS
                      If( lBorder, If( l2007, 0, WS_BORDER ), 0 ),;
                      If( lBorder .and. ;
                      ! Upper( oWnd:ClassName() ) $ "TBAR;TOUTLOOK;TXBROWSE", WS_TABSTOP, 0 ),;
                      If( ( ! lBorder ) .and. oWnd:IsKindOf( "TDIALOG" ), WS_TABSTOP, 0 ) )

   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = nTop
   ::nLeft     = nLeft

   if Empty( nWidth ) .and. Empty( nHeight )
      ::nBottom   = nTop + 20 - 1
      ::nRight    = nLeft + 20 - 1
   else
      ::nBottom   = nTop + nHeight - 1
      ::nRight    = nLeft + nWidth - 1
   endif

   ::lPressed  = .F.
   ::lWorking  = .F.
   ::lAdjust   = lAdjust
   ::lDrag     = lDesign
   ::lCaptured = .F.
   ::bWhen     = bWhen
   ::nClrText  = ::oWnd:nClrText
   ::nClrPane  = GetSysColor( COLOR_BTNFACE )
   ::lUpdate   = lUpdate
   ::l97Look   = !lBorder
   ::lBorder   = lBorder
   ::lBtnDown  = .F.
   ::nLayout   = AScan( aLayouts, cLayout )
   ::lRound    = lRound

   ::lTransparent = lTransparent

   ::cToolTip = cToolTip

   ::lBoxSelect = .T.

   ::aAlpha    = { .F., .F., .F., .F. } //for all possible bitmaps

   ::hAlphaLevel = 255

   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0

   ::cCaption  = cPrompt
   ::SetFont( oFont )
   ::nDlgCode  = If( ::oWnd:IsKindOf( "TBAR" ), nil, DLGC_WANTALLKEYS )
   ::lMOver    = .F.
   ::l2007     = l2007
   ::l2010     = l2007

   ::nClrTextDis = ::nClrText

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::GetFont()
      ::SetColor( If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::nClrPane )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if Empty( bGradColors )
      ::bClrGrad = ::oWnd:bClrGrad
   else
      ::bClrGrad = bGradColors
   endif

   if l2007
      DEFAULT ::bClrGrad := { | lInvert | If( lInvert, ;
         { { 1/3, nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ) }, ;
           { 2/3, nRGB( 255, 215,  84 ), nRGB( 255, 233, 162 ) }  ;
         }, ;
         { { 1/2, nRGB( 219, 230, 244 ), nRGB( 207-50, 221-25, 255 ) }, ;
           { 1/2, nRGB( 201-50, 217-25, 255 ), nRGB( 231, 242, 255 ) }  ;
         } ) }
   endif

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3, cResName4, cBmpFile4  )

   if Empty( nWidth ) .and. Empty( nHeight )
      // ::SetPos( ::nTop, ::nLeft )
      // ::SetSize( nBmpWidth( ::hBitmap1 ), nBmpHeight( ::hBitmap1 ), .T. )
      ::nWidth = nBmpWidth( ::hBitmap1 ) + 2
      ::nHeight = nBmpHeight( ::hBitmap1 ) + 2
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction,;
               lGroup, oBar, lAdjust, bWhen, cToolTip, lPressed,;
               bDrop, cAction, nPos, cPrompt, oFont, cResName3, cBmpFile3,;
               lBorder, oPopup, cLayout, cResName4, cBmpFile4, lTransparent) CLASS TBtnBmp

   DEFAULT cMsg := "", lAdjust := .F., lPressed := .F., lBorder := .T.,; //ojo
           cLayout := "TOP", lTransparent := .F.

   if oBar:IsKindOf( "TBAR" ) .and. ( oBar:l2007 .or. oBar:l2010 )
      ::nStyle    = nOR( WS_CHILD, WS_VISIBLE )
      ::l2007     = oBar:l2007
      ::l2010     = oBar:l2010
   else
      if oBar:IsKindOf( 'TBAR' ) .and. oBar:l97Look != nil
         lBorder  = ! oBar:l97Look
      endif
      ::nStyle    = nOR( If( lBorder, WS_BORDER, 0 ), WS_CHILD, WS_VISIBLE )
   endif

   ::l97Look   = !lBorder
   ::nId       = ::GetNewId()
   ::oWnd      = oBar
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = oBar:GetBtnTop( lGroup, nPos )
   ::nLeft     = oBar:GetBtnLeft( lGroup, nPos )
   ::nBottom   = ::nTop + oBar:nBtnHeight + 1 - If( oBar:l3D .and. !oBar:l2007, 7, 0 )
   ::nRight    = ::nLeft + oBar:nBtnWidth - If( oBar:l3D .and. !oBar:l2007, 2, 0 ) + ;
                 If( oPopup != nil, 13, 0 )
   ::lPressed  = lPressed
   ::lCaptured = .F.
   ::lWorking  = .F.
   ::lDrag     = .F.
   ::lBtnDown  = lPressed
   ::lAdjust   = lAdjust
   ::lGroup    = lGroup
   ::bWhen     = bWhen
   ::nClrText  = ::oWnd:nClrText
   ::nClrPane  = GetSysColor( COLOR_BTNFACE )
   ::oCursor   = oBar:oCursor
   ::cToolTip  = cToolTip
   ::bDropOver = bDrop
   ::cResName1 = cResName1
   ::cResName2 = cResName2
   ::cBmpFile1 = cBmpFile1
   ::cBmpFile2 = cBmpFile2
   ::cAction   = cAction
   ::cCaption  = cPrompt
   ::SetFont( oFont )
   ::lBorder   = lBorder

   ::aAlpha    = { .F., .F., .F., .F. } // for all possible bitmaps

   ::lTransparent = lTransparent

   ::lBoxSelect = .T.

   ::nLayout   = AScan( aLayouts, cLayout )
   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0

   ::oPopup    = oPopup
   ::nDlgCode  = If( Upper( ::oWnd:ClassName() ) == "TBAR", nil, DLGC_WANTALLKEYS )
   ::lMOver    = .F.
   ::lBarBtn   = .T.

   ::nClrTextDis = ::nClrText

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::Create()
   oBar:Add( Self, nPos )
   ::SetColor( If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ), ::nClrText ), ::nClrPane )

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3, cResName4, cBmpFile4 )

   ::bClrGrad = nil

   if bWhen != nil .and. ! ::lWhen()
      ::Disable()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg,;
                 bAction, oBar, lAdjust, bWhen, lUpdate, cToolTip,;
                 cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
                 l2007, cResName4, cBmpFile4, lTransparent, lRound, bGradColors ) CLASS TBtnBmp

   DEFAULT cMsg := "", lAdjust := .F., lUpdate := .F., lBorder := .T.,;
           cLayout := "TOP", l2007 := .F., oBar := GetWndDefault(), lRound := .F.

   ::l97Look   = ! lBorder
   ::nId       = nId
   ::oWnd      = oBar
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::lPressed  = .F.
   ::lCaptured = .F.
   ::lWorking  = .F.
   ::lDrag     = .F.
   ::lAdjust   = lAdjust
   ::bWhen     = bWhen
   ::nClrPane  = GetSysColor( COLOR_BTNFACE )
   ::lUpdate   = lUpdate
   ::cToolTip  = cToolTip
   ::cCaption  = cPrompt
   ::SetFont( oFont )
   ::lBorder   = lBorder
   ::lBtnDown  = .F.
   ::nLayout   = AScan( aLayouts, cLayout )
   ::nDlgCode  = DLGC_WANTALLKEYS
   ::lMOver    = .F.

   ::aAlpha    = {.F.,.F.,.F.,.F.} //for all possible bitmaps

   ::lTransparent = lTransparent

   ::lBoxSelect = .T.

   ::hAlphaLevel = 255

   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0
   ::lBarBtn   = .F.
   ::l2007     = l2007
   ::l2010     = l2007
   ::lRound    = lRound

   ::nClrTextDis = ::nClrText

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oBar:DefControl( Self )

   if Empty( bGradColors )
      ::bClrGrad = ::oWnd:bClrGrad
   else
      ::bClrGrad = bGradColors
   endif

   if ( ! ::lBarBtn ) .and. l2007
      DEFAULT ::bClrGrad := { | lInvert | If( lInvert, ;
         { { 1/3, nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ) }, ;
           { 2/3, nRGB( 255, 215,  84 ), nRGB( 255, 233, 162 ) }  ;
         }, ;
         { { 1/2, nRGB( 219, 230, 244 ), nRGB( 207-50, 221-25, 255 ) }, ;
           { 1/2, nRGB( 201-50, 217-25, 255 ), nRGB( 231, 242, 255 ) }  ;
         } ) }
   endif

   ::LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                  cResName3, cBmpFile3, cResName4, cBmpFile4 )

return Self

//----------------------------------------------------------------------------//

METHOD Click() CLASS TBtnBmp

   if ::bWhen != NIL
      if ! Eval( ::bWhen )
         MsgBeep()
         return NIL
      endif
   endif

   if ! ::lProcessing // .and. ! ::lPressed
      ::lProcessing = .T.

      if ::bAction != nil
         Eval( ::bAction, Self )
      endif

      ::Super:Click()         // keep it here, the latest!
      ::lProcessing = .F.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetBmp() CLASS TBtnBmp

   ::hBmp = If( ::lPressed, If( Empty( ::hBitmap2 ), If( ::lMOver .and. ;
                 ! Empty( ::hBitmap4 ), ::hBitmap4, ::hBitmap1 ),;
                 ::hBitmap2 ), If( ! IsWindowEnabled( ::hWnd ) .and. ;
                 ! Empty( ::hBitmap3 ), ::hBitmap3, If( ::lMOver .and. ;
                 ! Empty( ::hBitmap4 ), ::hBitmap4, ::hBitmap1 ) ) )

   ::nBtn = If( ::lPressed, If( Empty( ::hBitmap2 ), If( ::lMOver .and. ;
                ! Empty( ::hBitmap4 ), 4, 1 ), 2 ),;
                If( ! IsWindowEnabled( ::hWnd ) .and. ! Empty( ::hBitmap3 ),;
                3, If( ::lMOver .and. ! Empty( ::hBitmap4 ), 4, 1 ) ) )

   if SetAlpha() .and. ::aAlpha[ ::nBtn ]
      ::nAlphaLevel()
      if ::lAdjust
         ::hBmp = ResizeBmp( ::hBmp, ::nWidth, ::nHeight )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GotFocus( hCtlLost ) CLASS TBtnBmp

   local nWidth, hPen, hDC, hOldBrush
   local nAdj := 0

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_TABSTOP )
      if ( nWidth := ::nWidth() ) > NO_FOCUSWIDTH
         if ::lEllipse
            ::DrawFocusEllipse( ::GetDC() )
         else
            nAdj = If( ::l2007 .or. ::l2010, 2, 0 )
            DrawFocusRect( ::GetDC(), 2, 2, ::nHeight() - 4 + nAdj, nWidth - 4 + nAdj )
         endif
         ::ReleaseDC()
      endif
   endif

return ::Super:GotFocus()

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TBtnBmp

   local uValue
   local nOldStyle := ;
   SetWindowLong( ::hWnd, GWL_EXSTYLE,;
                  nXor( GetWindowLong( ::hWnd, GWL_EXSTYLE ), WS_EX_CLIENTEDGE ) )

//   MsgInfo( GetWindowLong( ::hWnd, GWL_EXSTYLE ) == nOldStyle )

   SetWindowPos( ::hWnd, 0, 0, 0, 0,;
                 nOr( SWP_NOMOVE, SWP_NOSIZE, SWP_FRAMECHANGED ), 1 )

   ::SetColor( If( ValType( ::nClrText ) == "B", Eval( ::nClrText, ::lMOver ),;
               ::nClrText ), ::nClrPane )

   uValue = ::Super:Initiate( hDlg )

   DEFAULT ::cCaption := GetWindowText( ::hWnd )

return uValue

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TBtnBmp

   if nKey == VK_RETURN .or. nKey == VK_SPACE
      ::lPressed = .T.
      ::Refresh()
   else
      return ::Super:KeyChar( nKey, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD nAlphaLevel( uNew ) CLASS TBtnBmp

   if uNew != NIL
      ::hAlphaLevel := uNew
   else
      if ::bAlphaLevel != NIL
         ::hAlphaLevel = eval( ::bAlphaLevel, Self )
      endif
   endif

return ::hAlphaLevel

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TBtnBmp

   local nWidth, nAdj

   if ::l97Look .and. ::lBorder
      ReleaseCapture()
      ::lBorder := .F.
      ::Refresh()
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_TABSTOP )
      if ( nWidth := ::nWidth() ) > NO_FOCUSWIDTH
         nAdj = If( ::l2007 .or. ::l2010, 2, 0 )
         if ! ::lEllipse
            DrawFocusRect( ::GetDC(), 2, 2, ::nHeight() - 4 + nAdj, nWidth - 4 + nAdj )
            ::ReleaseDC()
         endif
      endif
      ::Refresh()
   endif

return ::Super:LostFocus()

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TBtnBmp

   local cPrg := ""

   cPrg += CRLF + CRLF + "   DEFINE BTNBMP OF oBar " + ;
              'ACTION MsgInfo( "Not defined yet" )'

return cPrg

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TBtnBmp

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return ::Super:LButtonDown( nRow, nCol )
   endif

   ::lWorking = .T.
   ::lBtnUp   = .F.

   SetFocus( ::hWnd )    // To let the main window child control
   SysRefresh()          // process its valid

   if GetFocus() == ::hWnd
      ::lCaptured = .T.
      ::lPressed  = .T.
      ::Capture()
      ::Refresh() // .F.
   endif

   ::lWorking = .F.

   if ::lBtnUp
      ::LButtonUp( nRow, nCol )
      ::lBtnUp = .F.
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol )  CLASS TBtnBmp

   local oWnd
   local lClick := IsOverWnd( ::hWnd, nRow, nCol )

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return ::Super:LButtonUp( nRow, nCol )
   endif

   if ::bLButtonUp != nil
      Eval( ::bLButtonUp, nRow, nCol)
   endif

   ::lBtnUp  = .T.

   if ! ::lWorking
      if ::lCaptured
         ::lCaptured = .F.
         ReleaseCapture()
         if ! ::lPressed
            if ::lBtnDown
               ::lPressed = .T.
               ::Refresh()
            endif
         else
            if ! ::lBtnDown
               ::lPressed = .F.
               ::Refresh()
            endif
         endif
         if lClick
            if ::oPopup != nil
               if nCol >= ::nWidth() - 13
                  if ::oWnd:oWnd != nil .and. Upper( ::oWnd:oWnd:Classname() ) == "TBAR"
                     oWnd := ::oWnd:oWnd
                  else
                     oWnd := ::oWnd
                  endif
                  oWnd:NcMouseMove() // close the tooltip
                  oWnd:oPopup = If( ValType( ::oPopup ) == 'B', Eval( ::oPopUp, Self ), ::oPopUp )
//                  ::oPopup:Activate( ::nTop + ::nHeight(), ::nLeft, oWnd, .F. )

                  oWnd:oPopup:Activate( ::nTop + ::nHeight(), Max( ::nLeft, 1 ), oWnd, .F. )
                  if ValType( ::oPopUp ) == 'B'
                     oWnd:oPopUp:End()
                  endif
                  oWnd:oPopup = nil
                  ::Refresh()
               else
                  ::Click()
               endif
            else
               ::Click()
            endif
         endif
      endif
   endif

return 0

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TBtnBmp

   ::FreeBitmaps()

   if ValType( ::oPopUp ) == 'O'
      ::oPopup:End()
   endif

   if ! Empty( ::hRgn )
      DeleteObject( ::hRgn )
   endif

return ::Super:Destroy()

//----------------------------------------------------------------------------//

METHOD DrawEllipse( hDC, nRGBColor, n ) CLASS TBtnBmp

   local hOldBrush := SelectObject( hDC, GetStockObject( NULL_BRUSH ) )
   local hPen := CreatePen( hDC, 1, nRGBColor )

   DEFAULT n := 0

   Ellipse( hDC, n, n, ::nWidth - 1 - n, ::nHeight - 1 - n, hPen )

   SelectObject( ::hDC, hOldBrush )
   DeleteObject( hPen )

return nil

//----------------------------------------------------------------------------//

METHOD DrawFocusEllipse( hDC ) CLASS TBtnBmp

   local nPoints := 1.83 * SQRT( ( ( ::nWidth / 2 ) * ( ::nWidth / 2 ) + ;
                    ( ::nHeight / 2 ) * ( ::nHeight / 2 ) ) / 2 )

   DrawFocusEllipse( ::hWnd, hDC, 10, nPoints )

return nil

//----------------------------------------------------------------------------//

METHOD SetFile( cBmpUpFile, cBmpDownFile ) CLASS TBtnBmp

   ::FreeBitmaps()
   ::LoadBitmaps( nil, nil, cBmpUpFile, cBmpDownFile )
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD FreeBitmaps() CLASS TBtnBmp

   if ::hBitmap1 != 0
      PalBmpFree( ::hBitmap1, ::hPalette1 )
   endif

   if ::hBitmap2 != 0
      PalBmpFree( ::hBitmap2, ::hPalette2 )
   endif

   if ::hBitmap3 != 0
      PalBmpFree( ::hBitmap3, ::hPalette3 )
   endif

   if ::hBitmap4 != 0
      PalBmpFree( ::hBitmap4, ::hPalette4 )
   endif


   ::hBitmap1  = 0
   ::hPalette1 = 0
   ::hBitmap2  = 0
   ::hPalette2 = 0
   ::hBitmap3  = 0
   ::hPalette3 = 0
   ::hBitmap4  = 0
   ::hPalette4 = 0

   afill( ::aAlpha, .F. )


return nil

//----------------------------------------------------------------------------//

METHOD LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                    cResName3, cBmpFile3, cResName4, cBmpFile4 ) CLASS TBtnBmp

   local aBmpPal

  if ! Empty( cResName1 )
     IF  FindResource( GetResources(), cResName1 , 10 )  != 0
         ::hBitmap1  =  FILoadFromMemory( cResToStr( cResName1, 10 ), 10 )
         ::hPalette1 = 0
         ::cResName1 = cResName1
     ELSE
        aBmpPal = PalBmpLoad( cResName1 )
        ::hBitmap1  = aBmpPal[ 1 ]
        ::hPalette1 = aBmpPal[ 2 ]
        ::cBmpFile1 = cResName1
     endif
     ::HasAlpha( ::hBitmap1, BTN_UP )
  endif

  if ! Empty( cResName2 )
   IF  FindResource( GetResources(), cResName2 , 10 )  != 0
         ::hBitmap2  =  FILoadFromMemory( cResToStr( cResName2, 10 ), 10 )
         ::hPalette2 = 0
         ::cResName2 = cResName2
     ELSE
         aBmpPal = PalBmpLoad( cResName2 )
         ::hBitmap2  = aBmpPal[ 1 ]
         ::hPalette2 = aBmpPal[ 2 ]
         ::cBmpFile2 = cResName2
     endif
      ::HasAlpha( ::hBitmap2, BTN_DOWN )
   endif

   if ! Empty( cResName3 )
     IF  FindResource( GetResources(), cResName3 , 10 )  != 0
         ::hBitmap3  =  FILoadFromMemory( cResToStr( cResName3, 10 ), 10 )
         ::hPalette3 = 0
         ::cResName3 = cResName3
     ELSE
         aBmpPal = PalBmpLoad( cResName3 )
         ::hBitmap3  = aBmpPal[ 1 ]
         ::hPalette3 = aBmpPal[ 2 ]
         ::cBmpFile3 = cResName3
     endif
     ::HasAlpha( ::hBitmap3, BTN_DISABLE )
   endif

   if ! Empty( cResName4 )
     IF  FindResource( GetResources(), cResName4 , 10 )  != 0
         ::hBitmap4  =  FILoadFromMemory( cResToStr( cResName4, 10 ), 10 )
         ::hPalette4 = 0
         ::cResName4 = cResName4
     ELSE
         aBmpPal = PalBmpLoad( cResName4 )
         ::hBitmap4  = aBmpPal[ 1 ]
         ::hPalette4 = aBmpPal[ 2 ]
         ::cBmpFile4 = cResName4
     endif
     ::HasAlpha( ::hBitmap4, BTN_OVERMOUSE )
   endif

   if ! Empty( cBmpFile1 )
      if File( cBmpFile1 )
         ::cBmpFile1 = cBmpFile1
         if Upper( Right( cBmpFile1, 3 ) ) == "PNG"
            ::hBitmap1  = FWOpenPngFile( cBmpFile1 )
            ::hPalette1 = 0
         else
            aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile1 )
            ::hBitmap1  = aBmpPal[ 1 ]
            ::hPalette1 = aBmpPal[ 2 ]
            ::ReleaseDC()
         endif
         ::cBmpFile1 = cBmpFile1
         ::HasAlpha( ::hBitmap1, BTN_UP )
      endif
   endif

   if ! Empty( cBmpFile2 )
      if File( cBmpFile2 )
         ::cBmpFile2 = cBmpFile2
         if Upper( Right( cBmpFile2, 3 ) ) == "PNG"
            ::hBitmap2  = FWOpenPngFile( cBmpFile2 )
            ::hPalette2 = 0
         else
            aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile2 )
            ::hBitmap2  = aBmpPal[ 1 ]
            ::hPalette2 = aBmpPal[ 2 ]
            ::ReleaseDC()
         endif
         ::HasAlpha( ::hBitmap2, BTN_DOWN )
         ::cBmpFile2 = cBmpFile2
      endif
   endif

   if ! Empty( cBmpFile3 )
      if File( cBmpFile3 )
         ::cBmpFile3 = cBmpFile3
         if Upper( Right( cBmpFile3, 3 ) ) == "PNG"
            ::hBitmap3  = FWOpenPngFile( cBmpFile3 )
            ::hPalette3 = 0
         else
            aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile3 )
           ::hBitmap3  = aBmpPal[ 1 ]
           ::hPalette3 = aBmpPal[ 2 ]
           ::ReleaseDC()
         endif
         ::HasAlpha( ::hBitmap3, BTN_DISABLE )
         ::cBmpFile3 = cBmpFile3
      endif
   endif

   if ! Empty( cBmpFile4 )
      if File( cBmpFile4 )
         ::cBmpFile4 = cBmpFile4
         if Upper( Right( cBmpFile4, 3 ) ) == "PNG"
            ::hBitmap4  = FWOpenPngFile( cBmpFile4 )
            ::hPalette4 = 0
         else
            aBmpPal     = PalBmpRead( ::GetDC(), cBmpFile4 )
           ::hBitmap4  = aBmpPal[ 1 ]
           ::hPalette4 = aBmpPal[ 2 ]
           ::ReleaseDC()
         endif
         ::HasAlpha( ::hBitmap4, BTN_OVERMOUSE )
         ::cBmpFile4 = cBmpFile4
      endif
   endif

   if ! Empty( ::hBitmap1 )
      PalBmpNew( ::hWnd, ::hBitmap1, ::hPalette1 )
   endif

   if ! Empty( ::hBitmap2 )
      PalBmpNew( ::hWnd, ::hBitmap2, ::hPalette2 )
   endif

   if ! Empty( ::hBitmap3 )
      PalBmpNew( ::hWnd, ::hBitmap3, ::hPalette3 )
   endif

   if ! Empty( ::hBitmap4 )
      PalBmpNew( ::hWnd, ::hBitmap4, ::hPalette4 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TBtnBmp

   if ! ::lMOver
      ::lMOver = .T.
      ::Refresh()
   endif

   if ::lDrag .or. ! Empty( ::oDragCursor )
      return ::Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   ::Super:MouseMove( nRow, nCol, nKeyFlags )

   if ! ( ::l2007 .or. ::l2010 )
      if IsOverWnd( ::hWnd, nRow, nCol )
         if !::lCaptured
            if ::l97Look
               ::Capture()
               if ! ::lBorder
                  ::lBorder = .T.
                  ::Refresh()
               endif
            endif
         else
            if ! ::lPressed
               ::lPressed = .T.
               ::Refresh()
            endif
         endif
      else
         if ! ::lCaptured
            if ::l97Look
               ReleaseCapture()
               if ::lBorder
                  ::lBorder = .F.
                  ::Refresh()
               endif
            endif
         else
            if ::lPressed
               ::lBorder  =  ! ::l97Look
               ::lPressed = .F.
               ::Refresh()
            endif
         endif
      endif
   endif

   ::oWnd:SetMsg( ::cMsg )

   TrackMouseEvent( ::hWnd, TME_LEAVE )

return 0

//----------------------------------------------------------------------------//

METHOD PaintBackGroundAs20072010() CLASS TBtnBmp

   local nAdjustBorder

   if ::lBarBtn
      ::lRound = .F.
   endif

   if ::l2007 .or. ::l2010

      if ! ::lBarBtn
         if Empty( ::hRgn ) .and. ::lEllipse
            ::hRgn := CreateEllipticRgnIndirect( GetClientRect( ::hWnd ) )
            SetWindowRgn( ::hWnd, ::hRgn )
         endif

         if Empty( ::hRgn ) .and. ::lRound
            ::hRgn := CreateRoundRectRgn( GetClientRect( ::hWnd ), 6, 6 )
            SetWindowRgn( ::hWnd, ::hRgn )
         endif

         nAdjustBorder = If( ::lBorder, If( ::lBarBtn, 0, 3 ), 0 )

         if ! Empty( ::aGrad )
            GradientFill( ::hDC, 0,0, ::nHeight, ::nWidth, ::aGrad )
         endif

         if ::lBorder
            do case
               case ::lEllipse
                    ::DrawEllipse( ::hDC, RGB( 141, 178, 227 ), 0 )
                    ::DrawEllipse( ::hDC, RGB( 237, 242, 248 ), 1 )

                    if ::lFocused
                       ::DrawFocusEllipse( ::hDC )
                    endif

               case ::lRound
                    RoundBox( ::hDC, 1, 1, ::nWidth, ::nHeight, 6, 6, RGB( 237, 242, 248 ) )
                    RoundBox( ::hDC, 0, 0, ::nWidth - 1, ::nHeight, 6, 6, RGB( 141, 178, 227 ), 1 )

               otherwise
                    Rectangle( ::hDC, 0, 0, ::nHeight, ::nWidth )

                    if ::aGrad != nil
                       GradientFill( ::hDC, 1, 1, ::nHeight - 2, ::nWidth - 1, ::aGrad )
                    endif
            endcase
         endif
      else
         if ::aGrad != nil
            GradientFill( ::hDC, 0, 0, ::nHeight, ::nWidth, ::aGrad )
         endif
      endif
   endif

      /*
      if ::oPopUp != nil
         if ::nLayOut != 2 // left
            nBmpLeft -= 6
            if oBmpRect != nil
               oBmpRect:MoveBy( 0, -6 )
            endif
         endif
      endif
      */

return nil

//----------------------------------------------------------------------------//

METHOD PaintBackGroundStandard() CLASS TBtnBmp

   if ::lTransparent
      SetBrushOrgEx( ::hDC, nBmpWidth( ::oWnd:oBrush:hBitmap ) - ::nLeft,;
                     nBmpHeight( ::oWnd:oBrush:hBitmap ) - ::nTop )
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )
   else
      if Empty( ::bClrGrad )
         FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
      else
         if ::aGrad != nil
            GradientFill( ::hDC, 0, 0, ::nHeight, ::nWidth, ::aGrad() )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintBitmap() CLASS TBtnBmp

   local hBmp  := ::hBmp
   local nTop  := ( ::nHeight / 2 ) - ( nBmpHeight( hBmp ) / 2 )
   local nLeft := ( ::nWidth / 2 ) - ( nBmpWidth( hBmp ) / 2 )

   if ! Empty( ::cCaption )
      nTop -= 10
   endif

   if ::oPopup != nil
      nLeft -= 6
   endif

   if ::nLayOut == 2 // LEFT
      nTop  += 10
      nLeft -= 35
   endif
   
   if ::nLayOut == 4 // RIGHT
      nTop  += 10
      nLeft += 35
   endif      

   if ! Empty( hBmp )
      if ::lBmpTransparent
         if SetAlpha() .and. ::aAlpha[ ::nBtn ]
            ABPaint( ::hDC, nTop + If( ::lPressed, 1, 0 ),;
                     nLeft + If( ::lPressed, 1, 0 ), hBmp, ::nAlphaLevel() )
         else
            DrawTransBmp( ::hDC, hBmp, nTop + If( ::lPressed, 1, 0 ),;
                          nLeft + If( ::lPressed, 1, 0 ), nBmpWidth( hBmp ),;
                          nBmpHeight( hBmp ) )
         endif
      else
         DrawBitmap( ::hDC, hBmp, nTop + If( ::lPressed, 1, 0 ),;
                     nLeft + If( ::lPressed, 1, 0 ), nBmpWidth( hBmp ),;
                     nBmpHeight( hBmp ) )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintBorder() CLASS TBtnBmp

   local nAdjustBorder := 0

   if ::l2007 .or. ::l2010
      nAdjustBorder = If( ::lBorder, If( ::lBarBtn, 0, 3 ), 0 )
   endif

   if ::lMOver .and. ::lBoxSelect
      if ! ::lRound .and. ! ::lEllipse
         if ::l2007 .or. ::l2010
            WndBox2007( ::hDC, nAdjustBorder, nAdjustBorder,;
                        ::nHeight - nAdjustBorder - 1, ::nWidth - nAdjustBorder - 1,;
                        nRGB( 221, 207, 155 ) )
         else
            if ! ::lPressed
               WndRaised( ::hWnd, ::hDC )
            else
               WndInset( ::hWnd, ::hDC )
            endif      
         endif                     
      else
         if ::lEllipse
            ::DrawEllipse( ::hDC, nRGB( 221, 207, 155 ), 2 )
         else
            if ::lRound
               RoundBox( ::hDC, 2, 2, ::nWidth - 3, ::nHeight - 3, 6, 6,;
                         nRGB( 221, 207, 155 ) )
            else      
               if ! ::lPressed
                  WndRaised( ::hWnd, ::hDC )
               else
                  WndInset( ::hWnd, ::hDC )
               endif      
            endif   
         endif
      endif
   else
      if ::lBorder
         if ! ::lPressed
            if ! ( ::l2007 .or. ::l2010 )
               WndRaised( ::hWnd, ::hDC )
            endif
         else      
            WndInset( ::hWnd, ::hDC )
         endif   
      endif           
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintCaption() CLASS TBtnBmp

   local nStyle, nClr
   local hOldFont, aRect, lMultiline, cWord, cWord2
   local nOffset, nMaxWidth, nLine
   local nTxtTop, nTxtLeft, nTxtRight
   local nTxtHeight, nAdjust := 0
   local nLayOut := ::nLayOut

   if ! Empty( ::cCaption )

      if ::oFont == nil
         ::GetFont()
      endif

      lMultiLine = ! Empty( ::cCaption ) .and. CRLF $ ::cCaption

      if lMultiLine
         cWord = cStrWord( ::cCaption, nOffset, CRLF )

         while nOffset < Len( ::cCaption )
            nMaxWidth = Max( nMaxWidth,;
                             Len( cWord2 := cStrWord( ::cCaption, @nOffset, CRLF ) ) )
            if Len( cWord ) < nMaxWidth
              cWord = cWord2
            endif
         end

         nLine = MLCount( ::cCaption )
      else
         cWord      = ::cCaption
         nTxtHeight = GetTextHeight( ::hWnd, ::hDC )
         nTxtTop    = ::nHeight / 2 - nTxtHeight / 2 
         nMaxWidth  = GetTextWidth( 0, cWord, ::oFont:hFont )
         nTxtLeft   = ::nWidth / 2 - nMaxWidth / 2
         nTxtRight  = ::nWidth / 2 + nMaxWidth / 2 
      endif

      if ::nLayout == 2 // LEFT
         nTxtLeft  += nBmpWidth( ::hBmp ) / 2 - 10
         nTxtRight += nBmpWidth( ::hBmp ) / 2 - 10
      endif
      
      if ::nLayout == 4 // RIGHT
         nTxtLeft  -= nBmpWidth( ::hBmp ) / 2 - 5
         nTxtRight -= nBmpWidth( ::hBmp ) / 2 - 5
      endif

      nStyle = nOr( If( ::nLayOut == 0, DT_CENTER, nLayOut ), DT_WORDBREAK ,;
                    If( ::nLayOut % 2 == 0, DT_VCENTER, DT_TOP ) )

      nClr = If( IsWindowEnabled( ::hWnd ), ::nClrText,;
                 If( ::lDisColor, CLR_HGRAY, ::nClrTextDis ) )

      SetTextColor( ::hDC, If( ValType( nClr ) == "B", Eval( nClr, ::lMOver ), nClr ) )
      SetBkMode( ::hDC, 1 )

      if ::oWnd:oFont != nil .or. ::oFont != nil
         hOldFont = SelectObject( ::hDC, ::oFont:hFont )
      endif

      if ::oPopup != nil
         nTxtRight -= 12
      endif

      aRect = { nTxtTop, nTxtLeft - nMaxWidth / 2, ::nHeight - 4, nTxtRight + nMaxWidth / 2 }
      
      lMultiLine = ( nTxtHeight := DrawText( ::hDC, ::cCaption, aRect,;
                     nOr( DT_WORDBREAK, DT_CALCRECT ) ) ) > ;
                     DrawText( ::hDC, ::cCaption, aRect, nOr( DT_SINGLELINE, DT_CALCRECT ) )

      if ::nLayOut == 1 // TOP
         nStyle     = nOr( DT_CENTER, DT_WORDBREAK )
         aRect[ 1 ] = aRect[ 3 ] - nTxtHeight
      endif

      if ::nLayOut == 3
         aRect[ 1 ] = 2
      endif

      if ::lPressed
         aRect[ 1 ]++
         aRect[ 2 ]++
         aRect[ 3 ]++
         aRect[ 4 ]++
      endif   

      DrawText( ::hDC, ::cCaption, aRect, nStyle  )

      SelectObject( ::hDC, hOldFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TBtnBmp

   local aInfo := ::DispBegin()

   ::GetBmp()

   if ::l2007 .or. ::l2010
      ::PaintBackGroundAs20072010()
   else
      ::PaintBackGroundStandard()
   endif

   ::PaintBitmap()

   ::PaintCaption()

   ::PaintBorder()

   if ::oPopup != nil
      ::PaintPopupSection()
   endif

   ::DispEnd( aInfo )

return nil

//----------------------------------------------------------------------------//

METHOD PaintPopupSection() CLASS TBtnBmp

   local nWidth, nHeight, hDC
   local hBlackBrush, hOldBrush
   local hDarkPen, hLightPen, hOldPen

   if ::oPopup != nil
      nHeight = ::nHeight
      nWidth  = ::nWidth
      hDC     = ::hDC
      hBlackBrush = GetStockObject( 4 )
      hOldBrush   = SelectObject( hDC, hBlackBrush )

      PolyPolygon( hDC, { { nWidth - 9 + If( ::lPressed, 1, 0 ),;
         nHeight / 2 - 1 + If( ::lPressed, 1, 0 ) },;
         { nWidth - 7 + If( ::lPressed, 1, 0 ), nHeight / 2 + 1 + ;
           If( ::lPressed, 1, 0 ) },;
         { nWidth - 5 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + ;
           If( ::lPressed, 1, 0 ) },;
         { nWidth - 9 + If( ::lPressed, 1, 0 ), nHeight / 2 - 1 + ;
           If( ::lPressed, 1, 0 ) } } )

      if ::lBorder .or. ::lPressed .or. ::lMOver
         hDarkPen  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
         hLightPen = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )
         hOldPen = SelectObject( hDC, hLightPen )
         MoveTo( hDC, nWidth - 12 + If( ::lPressed, 1, 0 ), 1 )
         LineTo( hDC, nWidth - 12 + If( ::lPressed, 1, 0 ), nHeight - 1 )
         SelectObject( hDC, hDarkPen )
         MoveTo( hDC, nWidth - 13 + If( ::lPressed, 1, 0 ), 1 )
         LineTo( hDC, nWidth - 13 + If( ::lPressed, 1, 0 ), nHeight - 1 )
         SelectObject( hDC, hOldPen )
         DeleteObject( hDarkPen )
         DeleteObject( hLightPen )
      endif

      SelectObject( hDC, hOldBrush )
      DeleteObject( hBlackBrush )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TBtnBmp

   do case
      case nKey == VK_UP .or. nKey == VK_LEFT
           ::oWnd:GoPrevCtrl( ::hWnd )
      case nKey == VK_DOWN .or. nKey == VK_RIGHT
           ::oWnd:GoNextCtrl( ::hWnd )
   endcase


return ::Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TBtnBmp

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

   if nMsg == WM_SYSCHAR
      return ::SysChar( nWParam, nLParam )
   endif

   if nMsg == WM_KEYUP
      if ::lPressed
         ::lPressed := .F.
         ::Refresh()
         ::click()
      endif
   endif

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TBtnBmp

   ::lMOver = .F.
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD ShowPopup() CLASS TBtnBmp

   local oWnd

   if ::oPopup != nil
      if ::oWnd:oWnd != nil .and. Upper( ::oWnd:oWnd:Classname() ) == "TBAR"
         oWnd := ::oWnd:oWnd
      else
         oWnd := ::oWnd
      endif
      if GetClassName( GetParent( Self:hWnd ) ) != "TBAR"
         oWnd = oWndFromhWnd( GetParent( Self:hWnd ) )
      endif
      oWnd:NcMouseMove() // close the tooltip
      oWnd:oPopup = If( ValType( ::oPopup ) == 'B', Eval( ::oPopUp, Self ), ::oPopUp )
//      ::oPopup:Activate( ::nTop + ::nHeight(), ::nLeft, oWnd, .F. )
      oWnd:oPopup:Activate( ::nTop + ::nHeight(), Max( ::nLeft, 1 ), oWnd, .F. )
      if ValType( ::oPopUp ) == 'B'
         oWnd:oPopUp:End()
      endif
      oWnd:oPopup = nil
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetColor( nClrText, nClrPane ) CLASS TBtnBmp

   local nOldClrText := ::nClrText

   ::Super:SetColor( nClrText, nClrPane )

   if ValType( nOldClrText ) == "B"
      ::nClrText = nOldClrText
   endif

return nil

//----------------------------------------------------------------------------//

static function CheckArray( aArray )

   local nI
   local aRet := {}

   if ValType( aArray ) == 'A' .and. ;
      Len( aArray ) == 1 .and. ;
      ValType( aArray[ 1 ] ) == 'A'
      aArray   := aArray[ 1 ]
   endif

   for nI = 1 to 4
      if nI > len( aArray )
         AAdd( aRet, 0 )
      else
         AAdd( aRet, if( empty( aArray[ nI ] ), 0, aArray[ nI ] ) )
      endif
   next

return aRet

//----------------------------------------------------------------------------//

static function DrawTransBmp( hDC, hBmp, nRow, nCol, nWidth, nHeight )

   local hDCMem, hBmpOld, nOldClr, nZeroZeroClr

   DEFAULT nWidth := nBmpWidth( hBmp ), nHeight := nBmpHeight( hBmp )

   hDCMem = CreateCompatibleDC( hDC )

   // we can not get nZeroZeroClr from hDC is possible hDC are locked by other SelectObject
   // An application cannot select a bitmap into more than one device context at a time.
   hBmpOld      = SelectObject( hDCMem, hBmp )
   nZeroZeroClr = GetPixel( hDCMem, 0, 0 )

   SelectObject( hDCMem, hBmpOld )
   DeleteDC( hDCMem )

   nOldClr = SetBkColor( hDC, nRGB( 255, 255, 255 ) )
   TransBmp( hBmp, nBmpWidth( hBmp ), nBmpHeight( hBmp ), nZeroZeroClr, hDC, ;
             nCol, nRow, nWidth, nHeight )
   SetBkColor( hDC, nOldClr )

return nil

//----------------------------------------------------------------------------//

