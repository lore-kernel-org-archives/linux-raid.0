From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: raid 0 on different size devices?
Date: Wed, 19 Nov 2003 20:18:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311192018.14555.dusty@strike.wu-wien.ac.at>
References: <Pine.LNX.4.44.0311191154050.5855-100000@eglifamily.dnsalias.net> <1069268427.6956.21.camel@opus>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1069268427.6956.21.camel@opus>
Content-Disposition: inline
To: seth vidal <skvidal@phy.duke.edu>, Dan Egli <dan@eglifamily.dnsalias.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 19 November 2003 20:00, seth vidal wrote:
> On Wed, 2003-11-19 at 13:57, Dan Egli wrote:
> > Can the linux Software Raid handle devices of differing size? Basically
> > my issue is this: I've got two drives, a 27GB and a 40GB. I really want
> > to get them accessed as a single device. Is it possible to stack these
> > drives using like a raid 0?
>
> yes - but having the both be the same speed would be a good thing.

AFAIK they have to be of equal size but as you can create a 27GB partition on 
the 40GB drive, you could at least get 54GB out of this configuration. 

I have never used it but I think that LVM can also do just that: Concatenate 
multiple physical disks to one big logical.

If one disk is a lot slower than the other it could happen that the RAID0 is 
slower than the single disk.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

