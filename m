From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: RAID5 write hole?
Date: Sun, 27 Jun 2010 12:33:49 +0200
Message-ID: <4C27290D.6000609@xs4all.nl>
References: <20100626143125.GA1010@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100626143125.GA1010@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Shaochun Wang <scwang@ios.ac.cn>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaochun Wang wrote:
> Hi:
>
> Recently I heard of the so called "write hole" problem of raid5 in
> Linux software raid. I use ext4 filesystem on my NAS, which assembles
> data disks using Linux software raid. So I wonder how safe my such
> system!
>
> If the "write hole" is inevitable, will it result in the corruption of
> ext4 filesystem? 
The write hole occurs if your system crashes during a write operation, 
where one stripe gets updated but the other corresponding stripe does 
not.  This could lead to parity information not matching the 
corresponding data.

If the raid 5 system atleast ensures that the data stripe is always 
written before parity, then the montly resync check that mdadm does 
should be able to detect this and write new parity information.

Atleast this way the bad parity does not lurk around forever on your 
raid system causing numerous problems when a disk finally fails.

The write hole is not inevitable, but would require some special 
measures at the raid level which could affect performance.  And as with 
any corruption, it could definitely corrupt your filesystem.

--John

