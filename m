From: "Jason C. Leach" <jleach@ocis.net>
Subject: Stripe Block Size.
Date: Mon, 05 Apr 2004 08:51:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40718078.7010303@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi,

I have a Promise SX6000 in a RAID5 using Linux Debian on an AMD 
AthelonXP 2500+.  This array will store mostly GIS data. So about 30% 
large files (a few hundred megs) and 70% small files (several megs).  I 
am curious what stripe block size to use 4-64k (the fs is reiserfs).  I 
was thinking 32k for the stripe block size.

Thanks,
J.
