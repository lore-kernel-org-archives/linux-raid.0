From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Corrupted FS after recovery. Coincidence?
Date: Thu, 28 Feb 2013 09:37:55 +1100
Message-ID: <8cdfd8e6-99a1-4a0d-8bf2-afb408200239@email.android.com>
References: <512E6098.6040703@jamie-thompson.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512E6098.6040703@jamie-thompson.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jamie Thompson <jamierocks@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jamie Thompson <jamierocks@gmail.com> wrote:

>Here's the strange thing, it recovered very quickly, which I thought
>was 
>nice, but I wonder if it created a problem, as about an hour later I 
>started getting errors in my logs:

I'm not an expert in these things, but I would guess the following:
You re-added the partition instead of the drive, the MD metadata was at the end of the drive (same position regardless of whether it was a partition or a whole drive), and so MD just did a resync. However, the first section of the drive, or the offset of all data (from the beginning of the drive) was now wrong. You probably needed to clear the metadata on the drive before adding the partition to the array.

Someone else might confirm the above, but my suspicion is based on the fact that the resync was so quick (used the bitmap from the whole drive instead of making a new one for the partition).

PS, I'm glad you were able to get all your data back, though you should probably verify that nothing was corrupted in the process, perhaps from a backup restore and file comparison....

Regards,
Adam

Regards,
Adam

-- 
Adam Goryachev
Website Managers
Phone: 02 8304 0000
www.websitemanagers.com.au
