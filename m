From: Sebastien Koechlin <seb.kernel@koocotte.org>
Subject: Re: disk testing
Date: Fri, 17 Sep 2004 17:08:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040917150808.GK17204@koocotte.org>
References: <20040917025005.DC7F1395B@xprdmailfe9.nwk.excite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040917025005.DC7F1395B@xprdmailfe9.nwk.excite.com>
To: harry <hfranklin97@excite.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 16, 2004 at 10:50:05PM -0400, harry wrote:
> 
> Tim and Neil have suggested (apparently correctly) that the disk had a bad
> sector and the firmware remapped it when I wrote to it. My question is,
> how many spare sectors does the typical disk have? More importantly, since
> the sector has been remapped, recreating the raid5 array worked fine, but
> is a failure right out of the box normal? I was going to return it but
> since its working now I'm not sure if I should or not.

Can you read SMART Attributes under any OS?

Every disk I use, have a SMART Reallocated_Sector_Ct Attribute:

------

# smartctl -A /dev/hde
smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID ATTRIBUTE_NAME        FLAG   VALUE WORST THRESH TYPE     UPDATED RAW_VALUE
 1 Raw_Read_Error_Rate   0x000f 065   063   006    Pre-fail Always  147852401
 3 Spin_Up_Time          0x0003 100   100   000    Pre-fail Always  0
 4 Start_Stop_Count      0x0032 100   100   020    Old_age  Always  0
 5 Reallocated_Sector_Ct 0x0033 100   100   036    Pre-fail Always  0
(...)

------

You should search for your hard-drive datasheet, but RAW_VALUE is probably a
counter of remapped sectors.

If RAW_VALUE is high, if VALUE is low and going near THRESH, it means you're
going to have troubles with this disk.

You can read http://www.linuxjournal.com/article.php?sid=6983

-- 
Seb, autocuiseur
