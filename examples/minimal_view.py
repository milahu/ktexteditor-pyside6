from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtCore import Qt

# Import the generated module (built as KTextEditor.<ext>)
import KTextEditor

def main():
    app = QApplication([])

    # Get the singleton editor and make a document + view
    editor = KTextEditor.Editor.instance()
    doc = editor.createDocument(None)  # parent=None, managed by Qt parent later
    doc.setText("Hello from PySide6 + KTextEditor!\n\nThis is a minimal binding skeleton.")

    view = doc.createView(None)  # QWidget*
    win = QMainWindow()
    win.setCentralWidget(view)   # since View is a QWidget-derived class
    win.resize(800, 600)
    win.setWindowTitle("PySide6 + KF6::TextEditor (skeleton)")
    win.show()

    app.exec()

if __name__ == '__main__':
    main()
