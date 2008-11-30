From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: mdadm --incremental /dev/md?? instead of /dev/md/d??
Date: Sun, 30 Nov 2008 15:43:46 +0100
Message-ID: <200811301543.47003.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How can I switch the naming scheme for the mdadm incremental-mode 
using /dev/md42 instead of /dev/md/d42 for adding a device or 
constructing an array with a minor-number 42?

mdadm --version: 2.6.2

-- 
Wilhelm
