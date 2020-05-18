From: Sam Hurst <sam@sam-hurst.co.uk>
Subject: Re: RAID wiped superblock recovery
Date: Mon, 18 May 2020 19:52:47 +0100
Message-ID: <f88bfa57-8a17-eaa1-a926-33e2eb6ddb34@sam-hurst.co.uk>
References: <922713c5-0cc1-24cb-14a6-9de7db631f98@sam-hurst.co.uk>
 <0f954924-e7ae-c81e-55f1-afc41e293a18@turmel.org>
 <05011140-3625-5326-96c9-e995f93260f4@sam-hurst.co.uk>
 <e7644f86-5342-b7bb-b6de-b37afd74f6cc@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4FBEEC9466DC51A2C8C4793E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e7644f86-5342-b7bb-b6de-b37afd74f6cc@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------4FBEEC9466DC51A2C8C4793E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Phil,

On 17/05/2020 22:56, Phil Turmel wrote:
> Your math is wrong.  Or rather, you are using the bogus power-of-ten 
> definition of "MB" that disk manufacturers use to deliver less space.
> 
> Use 128MB.  Or better, specify "262144s".

Thanks very much, that was the final thing, and now I have a working 
array again and don't have to worry about pulling 6TB of data down from S3.

I had no idea that you could use sectors as a suffix to data-offset as 
it's not in the manpage. So you should find attached a patch file which 
adds that suffix to the manpage. If this isn't the correct place to 
provide patches, or if there's an issue with the formatting of my patch, 
please let me know and I'll happily update it and send it to the correct 
place.

Best Regards,
Sam

--------------4FBEEC9466DC51A2C8C4793E
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-PATCH-Add-sector-suffix-to-mdadm-data-offset-manpage.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-PATCH-Add-sector-suffix-to-mdadm-data-offset-manpage.pa";
 filename*1="tch"

From 116bc0ddeb29e848077480853a41c509518eb8ff Mon Sep 17 00:00:00 2001
From: Sam Hurst <sam@sam-hurst.co.uk>
Date: Mon, 18 May 2020 19:48:13 +0100
Subject: [PATCH] Add sector suffix to mdadm --data-offset manpage

---
 mdadm.8.in | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 9e7cb96..c997be4 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -857,8 +857,9 @@ an array which was originally created using a different version of
 which computed a different offset.
 
 Setting the offset explicitly over-rides the default.  The value given
-is in Kilobytes unless a suffix of 'K', 'M', 'G' or 'T' is used to explicitly
-indicate Kilobytes, Megabytes, Gigabytes or Terabytes respectively.
+is in Kilobytes unless a suffix of 'K', 'M', 'G', 'T' or 's' is used to
+explicitly indicate Kilobytes, Megabytes, Gigabytes, Terabytes or sectors
+respectively.
 
 Since Linux 3.4,
 .B \-\-data\-offset
-- 
2.17.1


--------------4FBEEC9466DC51A2C8C4793E--
