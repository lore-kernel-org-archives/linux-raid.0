From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Raid 5 rebuild and Raid 6 reshape question
Date: Sun, 19 Apr 2015 13:42:52 -0600
Message-ID: <7771744.HcGeMFsTMj@balsa>
References: <6744821.j7csV3RJVE@balsa> <1454025.2pEa89kuvv@balsa> <alpine.DEB.2.02.1504191041250.16871@uplift.swm.pp.se>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504191041250.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun 19 Apr 2015 10:43:32 AM Mikael Abrahamsson wrote:
> On Sat, 18 Apr 2015, Thomas Fjellstrom wrote:
> > problem. I was just curious as to how long an actual raid5->raid6
> > reshape would normally be or this setup. I expect it normally can take a
> > while as it has to rewrite a lot of data (11TiB worth).
> 
> In my experience it takes 5-15 times longer than a normal resync takes, to
> reshape from raid5->raid6. So for your 3TB disk size case, I'd say expect
> 4-8 days or so.

Ah. Good to know. mdstat was saying about 4-5 days. I kindof thought that was 
about normal given the amount of work involved to restripe all drives and 
calculate parity.

Thanks :)

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
