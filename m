From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Wed, 13 Mar 2013 08:32:47 +0100
Message-ID: <wrfj7glb92lc.fsf@redhat.com>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown> <wrfjlia2fd6h.fsf@redhat.com>
	<20130306131804.0b39752a@notabene.brown> <wrfj4ngog9h0.fsf@redhat.com>
	<20130312093231.72c54735@notabene.brown>
	<20130312123224.62018981@notabene.brown> <wrfjobeo91fb.fsf@redhat.com>
	<20130313103513.350f24f7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130313103513.350f24f7@notabene.brown> (NeilBrown's message of
	"Wed, 13 Mar 2013 10:35:13 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Tue, 12 Mar 2013 14:45:44 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
> There is a small race in the exclusion between discard and recovery.
> This patch on top should fix it (I hope).
> Thanks for testing.

I'll give it a spin. I am running on a quad-core Xeon system:
Intel(R) Xeon(R) CPU E3-1220 V2 @ 3.10GHz, with 8GB of RAM, and the
tests on a 3TB SATA III drive.

My loop image files are like this:
-rw-r--r--. 1 root root 268435456 Mar 12 09:53 img0
-rw-r--r--. 1 root root 268435456 Mar 12 09:53 img1
-rw-r--r--. 1 root root 268435456 Mar 12 09:53 img2
-rw-r--r--. 1 root root 268435456 Mar 12 09:26 img3

I've tried storing them both on ext4 and xfs, didn't seem to make a
difference for the test results.

Cheers,
Jes
