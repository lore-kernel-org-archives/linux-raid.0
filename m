From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: stride / stripe alignment on LVM ?
Date: Sun, 11 Nov 2007 23:53:41 +0000
Message-ID: <20071111235341.GA22855@agk.fab.redhat.com>
References: <20071101101037.63b523f8@absurd> <18218.24819.569744.141171@notabene.brown> <472B1F91.8000208@tmr.com> <20071102231605.7add5154@absurd> <1194115248.25553.59.camel@firewall.xsintricity.com> <20071103212118.5fd4c770@absurd> <87sl3ijuq0.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87sl3ijuq0.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 07, 2007 at 10:00:39AM +0100, Goswin von Brederlow wrote:
> I would just check with "dmsetup table dev" to which byte offsets the
> logical volume gets mapped to.
 
Or use:
  pvs -o+pe_start
(optionally with --units)

Alasdair
-- 
agk@redhat.com
