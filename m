From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] imsm: Forbid spanning between multiple controllers.
Date: Thu, 10 Jan 2013 16:57:53 -0500
Message-ID: <50EF3961.5050306@ubuntu.com>
References: <20121109144636.2215.91684.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121109144636.2215.91684.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Tomczak <marcin.tomczak@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/9/2012 9:46 AM, Marcin Tomczak wrote:
> Attaching disks to multiple controllers of the same type has been 
> allowed so far. Now spanning between multiple controllers is
> disallowed at all by IMSM metadata.

Does this mean that if you have a failure and try to recover by
plugging the disks into another machine where they are possibly not on
an IMSM controller at all, or split across different controllers,
mdadm will refuse to assemble the array?



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ7zlhAAoJEJrBOlT6nu75n/MIANZdgRyKBvJbKdLJlPtxzLLY
b1wlizB29YpX/tP+fJ7/O5r7u83tH/xFfruhSHgPSjnWxae8DGH84CLrs0uvMF+y
KD4/wacM288pWhq5WLLg9GeP266UAFAPNL3no39J6cZdOvPCLSrjsuvIx6YmSZ6E
2JniYreReDGoGqGvaLRb/dT2Qx6vF5D8M/6wV0ghuHlUYGx21QeMdHmI4SQmn8tJ
NGDl9p3bAYZ7poRhkTczOyICIhB33hg/hYkMoMc9I64U03kner4LNxsxE05zICZo
C/94KDWbIJV6Le6kxEE0pxeSKSrLj0I8kv/HoFUAi9cJY25y1N1IWQwqD3E35lg=
=GSbm
-----END PGP SIGNATURE-----
