From: "NeilBrown" <neilb@suse.de>
Subject: RE: Question on RAID-5 using ADMA
Date: Thu, 9 Jul 2009 19:37:06 +1000 (EST)
Message-ID: <718d9b820ffe02616088357a59af8737.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
    <C804A8D3A7CE4E9B8B6CE8DFD11019B9@m5>
    <8ba75cd82b7938995077e9e157f5b93f.squirrel@neil.brown.name>
    <AC5E1C3367E37D44970B81A6ADD1DA2C07B08866@SDCEXCHANGE01.ad.amcc.com>
    <9a56cb1758c9d7c935da72e9001d8e6b.squirrel@neil.brown.name>
    <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABF6@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABF6@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thu, July 9, 2009 5:26 pm, Tirumala Reddy Marri wrote:
> Make sense what you are saying. I am seeing file system errors during
> application data being written to file system on /def/md0 and rebuild is
> happening same time.  If I wait till it finishes re-build no errors seen
> on application data write(dd command).
>
> Question is RAID-5 rebuild has to happen completely before we any write to
> portions of disk which are not initialized yet ?

No.  You don't have to way for raid-5 rebuilt to complete.

Can you try disabling the ADMA and run exactly the same test.
If it works without ADMA, but fails with ADMA, then you know where
the problem is.

NeilBrown


