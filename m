From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Feature request for mdadm 3.3
Date: Mon, 7 May 2012 16:19:38 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.1205071616050.28839@filesrv1.baby-dragons.com>
References: <CAAOsTSn_mcy-W65zty727b=PCwp31qBgSANmGLzQv3DB2oBxiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-1759907984-1336436380=:28839"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSn_mcy-W65zty727b=PCwp31qBgSANmGLzQv3DB2oBxiw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-1759907984-1336436380=:28839
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

 	Hello Patrik and Neil ,

On Tue, 8 May 2012, Patrik Horník wrote:
> Hello,
>
> I have one feature request for mdadm 3.3, support for upgrade of
> metadata 0.9 to metadata 1.0.
>
> I guess there is a lot of old raid arrays with metadata 0.9 out there,
> because raid / lvm  are often used for its expansibility and longevity
> and thus I guess many of them evolved from old 0.9 raid arrays. At
> least I have a few of them.
>
> Upgrade to 1.0 is now of course very needed because of two new very
> important features in latest kernel versions requiring 1.x,
> hot-replace and badblock log.
>
> Manual upgrade by recreating array is pretty risky on important data,
> so support for this feature in mdadm would be very appreciated. What
> do you think guys, will it be useful feature?
>
> Thanks.
>
> Patrik Horník

 	One further suggestion ,  iirc 1.0 metadata is not compliant with auto 
assembled (Via Kernel, fd partition type) ,  That if mdadm notices an array 
created to be a 0.9 with partition type fd that it  BOLDLY announces at 
migration time that this MAY(Will ?) make the array nolonger auto assemble and 
to prepare for this eventuallity .

 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
--566704117-1759907984-1336436380=:28839--
