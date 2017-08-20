From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Sun, 20 Aug 2017 21:01:49 +0200
Message-ID: <cc201ff8ad3ca61c48c39c619ea6bd2e@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
 <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <7d0af770699948fb0ecb66185145be05@assyoma.it>
 <alpine.DEB.2.20.1708201241400.3655@uplift.swm.pp.se>
 <59998974.60103@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59998974.60103@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il 20-08-2017 15:07 Wols Lists ha scritto:
> Which is exactly what my "force integrity check on read" proposal would
> have achieved, but that generated so much heat and argument IN FAVOUR 
> of
> returning possibly corrupt data that I'll probably get flamed to high
> heaven if I bring it back up again.

I think the aversion to such an approach is due to:
a) a *big* performance degradation (you get the IOPs of a single disk);
b) the existence on all-encompassing checksummed filesystems as ZFS and 
BTRFS[1];
c) the difficulty to actually write such a code;
d) a understimating of how often can these data-corruption problem 
happens in real life.

I can not really blame MDRAID for what it provides, as it is incredibly 
flexible and very fast. Sure, a user-selectable option to auto 
discover/correct corrupted data would be great, but it seems that this 
is not the road MDRAID will ever take.

However, a possible solution would be to use dm-integrity on top of the 
single component devices of an MDRAID array. Give at look at stratis[2], 
it will be interesting...


[1] In the current state, I do not really trust BTRFS. I put much more 
hopes on ZoL...
[2] https://stratis-storage.github.io/StratisSoftwareDesign.pdf

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
