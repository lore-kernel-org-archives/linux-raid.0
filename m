From: Albert Pauw <albert.pauw@gmail.com>
Subject: -Y option patch
Date: Thu, 24 Feb 2011 15:31:16 +0100
Message-ID: <4D666BB4.20100@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030800030607010601020709"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030800030607010601020709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

  Hi Neil,

I noticed that the -Y option, as in mdadm -D -Y /dev/md0, doesn't work 
but used as --export it works.

So I made a little patch to fix it, but it is simply sticking a Y in the 
list of short_options in ReadMe.c.

Cheers,

Albert

--------------030800030607010601020709
Content-Type: text/plain;
 name="Y-option.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Y-option.patch"

--- ReadMe.c	2011-02-24 15:22:48.252985600 +0100
+++ ReadMe.c.me	2011-02-24 15:22:35.110625216 +0100
@@ -86,7 +86,7 @@
  *     At the time if writing, there is only minimal support.
  */
 
-char short_options[]="-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
+char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
 char short_bitmap_options[]=
                    "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
 char short_bitmap_auto_options[]=

--------------030800030607010601020709--
