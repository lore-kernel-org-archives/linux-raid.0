From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Migrating from SINGLE DISK to RAID1
Date: Tue, 01 Feb 2005 14:41:20 -0500
Message-ID: <41FFDB60.1040008@steeleye.com>
References: <41FFD1F8.3010101@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <41FFD1F8.3010101@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Robert,

Robert Heinzmann wrote:

> can someone verify if the following statements are true ?
> 
> - It's not possible to simply  convert a existing partition with a 
> filesystem on it to a raid1 mirror set.

If you create a raid1 without a superblock it is possible (although not 
a very common configuration). If you do use a superblock, you'll need to 
shrink your filesystem by 128KB (to be safe) prior to creating the mirror.

--
Paul
