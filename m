From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Adding a smaller drive
Date: Sun, 28 Jun 2009 17:49:53 -0400
Message-ID: <yq1ab3s111a.fsf@sermon.lab.mkp.net>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
	<yq1eit411s4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1eit411s4.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Sun, 28 Jun 2009 17:33:47 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> The IDEMA LBA standard applies to 3.5" form factor drives over
Martin> 160GB as well as 2.5" FF drives over 80 GB.

I should add that the above is for ATA drives.  For SCSI-class drives
the standard applies to 2.5" drives over 73GB and 3.5" drives over
450GB.

I did the maths for some common capacities:

Capacity (GB)	LBA count (512-byte blocks)
 250  		 488397168
 500  		 976773168
 750		1465149168
1000		1953525168
1500		2930277168
2000		3907029168

-- 
Martin K. Petersen	Oracle Linux Engineering
