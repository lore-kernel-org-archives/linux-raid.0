From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 09:33:37 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310270933.37564.dusty@strike.wu-wien.ac.at>
References: <1067179519.1222.107.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1067179519.1222.107.camel@cala>
Content-Disposition: inline
To: Mario Giammarco <mgiammarco@virgilio.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 26 October 2003 15:45, Mario Giammarco wrote:
> Hello,
> I would like to buy new SCSI hard disk to be used with lsi 160
> controller in 32 bit pci.
>
> I can choose:
>
> - RAID5 of three Maxtor Atlas 10K II 9gb
> - RAID1 of two   Maxtro Atlas 10K III 18gb
>
> My problem is: I have seen that RAID1 code does not interleave reads so
> it does not improve performance very much putting two hard disks.

You only have to keep in mind that the RAID5 CPU overhead is larger than the 
one of RAID1.

My experience is that software RAID5 is quite slow.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

