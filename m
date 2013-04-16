From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Question about resync in RAID5
Date: Tue, 16 Apr 2013 08:20:35 -0700
Message-ID: <3r604axnso.ln2@goaway.wombat.san-francisco.ca.us>
References: <1366106362-12886-1-git-send-email-sanbai@taobao.com>
 <516C62A8.4050900@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-04-15, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
> I highly doubt it, since, as said above, the md layer could not ever 
> possibly know what data is on the disk.

In theory it could, if it recorded metadata about what it's written over
the array's lifetime.  Some newer 3ware controllers claim to support
this feature (it's called something like "rapid RAID recovery").  Their
docs don't describe how or where this information is stored.

But AFAICT md doesn't support this feature.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


