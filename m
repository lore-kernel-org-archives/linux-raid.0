From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: mdadm: use Preferred Minor for non-standard named arrays?
Date: Mon, 3 Sep 2007 21:57:21 +0200
Message-ID: <fbhov1$bvd$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

using non-'standard' names for raid-arrays like /dev/md/root always
leads to (more or less) dynamically assigned device minors 127+.
Wouldn't it be possible to use the Preferred Minor hint from the
array's superblock or the super-minor option from the mdadm.conf?
This would lead to more stable minors and would thus make booting from
such devices a lot easier - especially for lilo systems :)


regards
   Mario
-- 
We know that communication is a problem, but the company is not going to
discuss it with the employees.
                       -- Switching supervisor, AT&T Long Lines Division

