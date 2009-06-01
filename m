From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Awful RAID5 random read performance
Date: Mon, 01 Jun 2009 06:43:28 -0600
Message-ID: <4A23CCF0.7030104@harddata.com>
References: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com> <200905312339.12234.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200905312339.12234.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Fjellstrom wrote:
> ..
> Yet I've heard NCQ makes some things worse. Some raid tweaking pages tell you 
> to try disabling NCQ.
>   

Not so relevant here.
This recommendation to  disable drive NCQ is generally due tot he fact 
that NCQ implementations by various manufacturers tend
to differ in behaviour, and, in some cases , is just plain "broken".


-- 
Regards, Maurice
