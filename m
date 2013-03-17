From: Chris Murphy <lists@colorremedies.com>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having alive mirrors?
Date: Sun, 17 Mar 2013 12:22:25 -0600
Message-ID: <7926492C-F638-4EE0-8BFF-90E6F662D8C1@colorremedies.com>
References: <1567316.0.1363525490131.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1567316.0.1363525490131.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 17, 2013, at 7:04 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
> 
> Have you done a SMART check of sdg? smartctl -H first, then smartctl -t short, then smartctl -t long (with smartctl -H between them)

The OP posted dmesg which clearly shows sdg reporting SATA ERR UNC messages with unreadable sectors. So we know sdg is a problem.

That doesn't explain why sdg is being read from during a rebuild of sdg. It doesn't explain whether md is getting data from sdf when there's a failed read from sdf.

That's why I think sdg needs to be taken out of the array entirely, a drive KNOWN to have bad sectors while rebuilding simply shouldn't be used. ATA Secure Erase it, or write zeros to it, separately, while doing a btrfs scrub of md3. And yes it's probably worth while to also do a smartctl -t long on sdf (the SSD).


>> You might also consider posting the configuration and full dmesg to
>> the btrfs list. I'm curious what btrfs developers think of this
>> configuration.
> 
> It's not btrfs - it's below that.

Btrfs is complaining about checksums not being found. But the configuration below btrfs, an SSD paired with an HDD set to write-mostly, isn't a configuration I've heard described on the btrfs list. Clearly in this setup, btrfs can't self-heal since it's not doing the raid1 itself. All it can do is report errors, which it's doing. So something's wrong with the file system too. It's not just a problem with sdg.


Chris Murphy