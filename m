From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] Use new sb type
Date: Mon, 28 Jan 2008 18:19:01 +0000
Message-ID: <479E1C95.1040008@dgreaves.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> This makes 1.0 the default sb type for new arrays.
> 

IIRC there was a discussion a while back on renaming mdadm options (google "Time
to  deprecate old RAID formats?") and the superblocks to emphasise the location
and data structure. Would it be good to introduce the new names at the same time
as changing the default format/on-disk-location?

David

