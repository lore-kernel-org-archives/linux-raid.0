From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Implementing Encryption and Decryption in Raid Device Driver.
Date: Tue, 20 Sep 2005 23:52:50 +0000
Message-ID: <62b0912f05092016525342c4c@mail.gmail.com>
References: <62b0912f050914123756d1f3d@mail.gmail.com>
	 <20050915073118.61198.qmail@web54703.mail.yahoo.com>
Reply-To: molle.bestefich@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050915073118.61198.qmail@web54703.mail.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: vinnakota chaitanya <chaitanyaa_v@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

vinnakota chaitanya wrote:
> 2. We were asked to use blow_fish algorithm instead.
> So, how to go about it, are there any modules like
> loop-aes or should I  consider the hooks
>  raid5_make_request and raid5_end_read_request
> for encryption and decryption

There's a "ciphers" package in the loop-aes directory on sourceforge
which adds Blowfish, Twofish and Serpent capability.  So hooking RAID5
for that purpose doesn't seem worthwhile.
