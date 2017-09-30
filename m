From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Accidentally resized array to 9
Date: Sat, 30 Sep 2017 21:29:11 +0500
Message-ID: <20170930212911.68547509@natsu>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
        <20170929175524.57fea3b5@natsu>
        <fec79486-8f23-74dd-9c62-4f89ac00b95d@benshoshan.com>
        <20170930005005.68beae8b@natsu>
        <de7d94b2-7d2c-1419-420d-65b6f531c37f@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de7d94b2-7d2c-1419-420d-65b6f531c37f@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On Sat, 30 Sep 2017 12:21:20 -0400
Phil Turmel <philip@turmel.org> wrote:

> > Ideally what you can hope for, is you would get the bulk of array data intact,
> > only with the first 9 KB of each device *(8-2), so about the first 54 KB of
> > data on the md array, corrupted and unusable. It is likely the LVM and
> > filesystem tools will not recognize anything due to that, so you will need to
> > use some data recovery software to look for and save the data.
> > 
> 
> I agree with Roman.  Most of your array should be still on the 8-disk
> layout.  But you were mounted and had writing processes immediately
> after the broken grow, so there's probably other corruption due to
> writes on the 9-disk pattern in the 8 disks.

Adding one afterthought that I had, you could probably salvage the 54 KB in
question by reading them in (and saving to a file) from the current
"9-device array of 9KB devices" that you got.

With respect,
Roman
