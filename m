From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: raid10_make_request bug: can't convert block across chunks or bigger [...]
Date: Tue, 2 Jan 2007 22:46:07 -0800
Message-ID: <8F1D223E-C668-497D-ADDF-52762882206F@develooper.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a logical volume I'm (trying to) use for a Xen box.   When  
it's installing the boot loader I get a bunch of errors like the ones  
below.  The kernel is the latest FC6 kernel - 2.6.18-1.2869.fc6xen.

The md device is a raid10 device (obviously) across 4 sata disks.

  Any ideas?

[....]
raid10_make_request bug: can't convert block across chunks or bigger  
than 64k 81830779 4
raid10_make_request bug: can't convert block across chunks or bigger  
than 64k 81847167 4
raid10_make_request bug: can't convert block across chunks or bigger  
than 64k 81879931 4
raid10_make_request bug: can't convert block across chunks or bigger  
than 64k 81896315 4
[...]


  - ask

-- 
http://develooper.com/ - http://askask.com/


