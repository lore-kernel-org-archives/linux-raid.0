From: Luca Berra <bluca@comedia.it>
Subject: Re: mdadm-3.1.1 segfaults when mdadm -G -Z
Date: Sat, 30 Jan 2010 10:56:11 +0100
Message-ID: <20100130095611.GC15471@maude.comedia.it>
References: <4B49C47A.9060800@mejor.pl> <4B49DA75.8090404@matfyz.cz> <4B49DBFA.1090508@mejor.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B49DBFA.1090508@mejor.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin =?iso-8859-2?Q?Miros=B3aw?= <marcin@mejor.pl>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Jan 10, 2010 at 02:54:02PM +0100, Marcin Mirosław wrote:
>W dniu 2010-01-10 14:47, Zdenek Behan pisze:
>>        -Z, --array-size=
>>               This is only meaningful with --grow and its effect is 
>> not  per‐
>>               sistent:  when  the  array  is  stopped an restarted the
>> default
>>               array size will be restored.
>
>Yes, i missed it.
>
>> You didn't supply any argument to -Z at all, or to be precise, you
>> supplied /dev/md6 as the argument, whereas you should have put in the
>> array size.
>> 
>> Also, another thing I have noticed lately is, that _some_ short options
>> seem to be somehow oddly broken on my system and not accepting
>> arguments, even if they are supposed to be. If the segfault persists
>> after using the correct syntax, try using the long opts instead. I was
>> planning to dig more into this bug myself, so I might just kick self to
>> do it now.
>
>long option, with suplied array size works correctly, so indeed problem
>is in short option.
>Thank you!
>Regards.

attached patch fixes it.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="0002-fix-segfault-when-Z-was-given-without-argument-repor.patch"

From d61bcf0c5f425bd4009f90cc1d467d933fde0a2c Mon Sep 17 00:00:00 2001
From: Luca Berra <bluca@vodka.it>
Date: Sat, 30 Jan 2010 10:46:07 +0100
Subject: [PATCH 2/2] =?UTF-8?q?fix=20segfault=20when=20-Z=20was=20given=20without=20argument=20(reported=20by=20Marcin
=20Miros=C5=82aw)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Signed-off-by: Luca Berra <bluca@vodka.it>
---
 ReadMe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index cd7b685..45619a4 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -86,11 +86,11 @@ char Version[] = Name " - v3.1.1 - 19th November 2009\n";
  *     At the time if writing, there is only minimal support.
  */
 
-char short_options[]="-ABCDEFGIQhVXWZvqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
+char short_options[]="-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
 char short_bitmap_options[]=
-                   "-ABCDEFGIQhVXWZvqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
+                   "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
 char short_bitmap_auto_options[]=
-                   "-ABCDEFGIQhVXWZvqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:";
+                   "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:";
 
 struct option long_options[] = {
     {"manage",    0, 0, '@'},
-- 
1.6.6.1


--C7zPtVaVf+AK4Oqc--
