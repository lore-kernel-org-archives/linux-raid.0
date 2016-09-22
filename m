From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 21:45:17 +0200
Message-ID: <20160922194517.GA6019@metamorpher.de>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
 <9c618b69-1e84-60a8-d25c-55171058c855@websitemanagers.com.au>
 <af2cbd12-ba6c-0e39-ba1d-651feda5d07c@spallek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <af2cbd12-ba6c-0e39-ba1d-651feda5d07c@spallek.org>
Sender: linux-raid-owner@vger.kernel.org
To: Axel Spallek <axel@spallek.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 22, 2016 at 08:41:59PM +0200, Axel Spallek wrote:
> root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1
> mdadm: /dev/md1: Need a backup file to complete reshape of this array.
> mdadm: Please provided one with "--backup-file=..."

I assume it was assembled anyway at this point so --stop again...

> root@s10:~# mdadm --assemble /dev/md1 /dev/sd[a-h]1 
> --backup-file=/var/backups/mdadm.backup
> mdadm: /dev/sda1 is busy - skipping
> mdadm: /dev/sdb1 is busy - skipping

regards
Andreas Klauer
