From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Raid over 48 disks ... for real now
Date: Thu, 17 Jan 2008 20:50:49 +0100
Message-ID: <20080117205049.32cf07e9@szpak>
References: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Norman Elton <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Norman Elton said:     (by the date of Thu, 17 Jan 2008 11:19:35 -0500)


> I wish RHEL would support XFS/ZFS, but for now, I'm stuck with ext3.

there is ext4 (or ext4dev) - it's an ext3 modified to support 1024 PB size
(1048576 TB). You could check if it's feasible. Personally I'd always
stick with ext2/ext3/ext4 since it is most widely used and thus has
the best recovery tools.

-- 
Janek Kozicki                                                         |
