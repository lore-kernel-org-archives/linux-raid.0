From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [md PATCH 00/10] md patches for 3.5: RAID10 reshape
Date: Sat, 01 Mar 2014 14:33:40 -0500
Message-ID: <53123614.7030100@ubuntu.com>
References: <20120403054656.19495.36380.stgit@notabene.brown>	<53116B4E.50306@ubuntu.com> <20140301180335.3cb5de75@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140301180335.3cb5de75@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 03/01/2014 02:03 AM, NeilBrown wrote:
> Why do you think mdadm doesn't yet support reshaping raid10?
> 
> commit 19ceb16dafb7df98ff90298008d4488dc93b370a Author: NeilBrown
> <neilb@suse.de> Date:   Thu Oct 4 16:34:21 2012 +1000
> 
> Grow: add raid10 reshape.
> 
> 
> $ git describe --contains 19ceb16dafb7df98ff90298008d4488dc93b370a 
> mdadm-3.3-rc1~192
> 
> 
> So mdadm-3.3 and later should do what you want.

Ahh, excellent.. I had searched but couldn't find that commit in the
git repo.  I guess it's time to upgrade.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJTEjYUAAoJEI5FoCIzSKrwFIUH/RWpQDZ7rZt1BahLhpYwxd/V
2ywVDKlK4qidbL5LoypGoFZQA2BEL2d+XzIajG5AOQ6OI0hwgJRJuOSATnAGO+iw
NRqMbkwAruEjt1Fg9dPYbgXbVAvQy/hZ24EHTiMwXrzHKmLYQvad3V5ghaQUGDYa
sYYEVq95aP54tPjET48r5IrD5ZoTdqHTrzjT490hpG6usNmEaCxMrGt2rxJxhPAO
asTWvGSheEr5A30rFTDan4PE96dOpjwd+aRGt3I5z2lIBxIYbQQ4qHxbZj4xoTq5
M4520lkVWNJ5u826kZeQ3YeGfjalaqfZ6YSgeFyUcFarnMS8QQ5xyQBa7XIjqs8=
=H9ub
-----END PGP SIGNATURE-----
