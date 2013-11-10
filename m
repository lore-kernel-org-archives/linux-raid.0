From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Sun, 10 Nov 2013 20:12:45 +0200
Message-ID: <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <527FCBAF.4070208@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Love for optimization :) I'm going to run check via cron job, and then I thought why not run e2fsck on the same day so that I do all the maintenance on the same day (in my configuration check requires some almost 48 hours for this raid1 2TB array when filesystem is mounted but it can run in foreground and results examined later, while e2fsck obviously requires some attention).

On Nov 10, 2013, at 8:08 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 11/10/2013 10:06 AM, Ivan Lezhnjov IV wrote:
>> Is this a good idea to run check and e2fsck on raid1 simultaneously? I'm leaning towards a definitive no, but then again I don't really know.
> 
> A more critical question is what current circumstances have prompted you
> to consider this?
> 
> -- 
> Stan
> 

