;;; cider-find-tests.el

;; Copyright © 2012-2019 Bozhidar Batsov

;; Author: Bozhidar Batsov <bozhidar@batsov.com>

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see `http://www.gnu.org/licenses/'.

;;; Commentary:

;; This file is part of CIDER

;;; Code:

(require 'buttercup)
(require 'cider-find)

(describe "cider-find-ns"
  (it "raises a user error if cider is not connected"
    (spy-on 'cider-connected-p :and-return-value nil)
    (expect (cider-find-ns) :to-throw 'user-error))
  (it "raises a user error if the op is not supported"
    (spy-on 'cider-nrepl-op-supported-p :and-return-value nil)
    (expect (cider-find-ns) :to-throw 'user-error)))


(describe "cider--find-ns"
  (before-each
    (spy-on 'cider-jump-to)
    (spy-on 'cider-find-file))
  (it "handles ordinary file paths"
    (let ((path "file:/path/to/file.suffix"))
      (spy-on 'cider-sync-request:ns-path :and-return-value path)
      (cider--find-ns "")
      (expect 'cider-find-file :to-have-been-called-with path)))
  (it "handles files in jars"
    (let ((path "file:/path/to/jar.jar!/path/file.suffix"))
      (spy-on 'cider-sync-request:ns-path :and-return-value path)
      (cider--find-ns "")
      (expect 'cider-find-file :to-have-been-called-with (concat "jar:" path)))))
