From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: parts -- Re: ext3 journal on software raid (was Re: PROBLEM:
 Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 19 Jan 2005 13:46:35 +0900
Message-ID: <41EDE62B.7030303@tequila.co.jp>
References: <Pine.LNX.3.96.1050105063502.9245A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105063502.9245A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@ns.Linux-Consulting.com>
Cc: Brad Campbell <brad@wasp.net.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/05/2005 11:44 PM, Alvin Oga wrote:

>>I have a 250GB drive I just swapped out that was "growing" bad sectors at the rate of 3 per day that 
>>did a clean badblocks 5 months ago when it was installed.
> 
> 
> you're buying bad hardware from bad vendors

seriously, thats just wrong. Ever heard of IBM "death"start HDs? Or
other stuff? As long as you use IDE hardware you are always close to
fail, IDE hardware is done to put much data on cheap disks.

If you use IDE stuff in servers, make all raid. And SWAP too, SWAP can
be used heavilty, and if there are bad blocks you are hit too.

A expensive vendor doesn't help you from crappy HW insealf.

- --
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TBWA\ && TEQUILA\ Japan IT Group                           ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-0061, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp        http://www.tbwajapan.co.jp ]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFB7eYrjBz/yQjBxz8RAnoeAKDs4ZdE+DPktmI8R/yBnFs44MvliQCg5OYy
Omq0O6Y5xqWNUFbmHorLyr8=
=GTZH
-----END PGP SIGNATURE-----
