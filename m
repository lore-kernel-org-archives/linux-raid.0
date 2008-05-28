From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: split off + mount a partitionless RAID1 device?
Date: Tue, 27 May 2008 18:32:50 -0700
Message-ID: <e03b90ae0805271832u6f64428emf34a28b284d05d9a@mail.gmail.com>
References: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
	 <483B916B.9060100@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483B916B.9060100@wasp.net.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>, Jeff Marshall <marshman@frozenbear.com>
List-Id: linux-raid.ids

> mount /dev/sdb /mnt
>
> Easy.

mount -t xfs -o nouuid /dev/sdb /backup

Just for the record... xfs required a little bit of cajoling to avoid
complaints like these.

mount: unknown filesystem type 'linux_raid_member'
[85439.832068] XFS: Filesystem sdb has duplicate UUID - can't mount
