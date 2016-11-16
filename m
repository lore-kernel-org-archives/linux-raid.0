From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Ddf based RAID management software
Date: Wed, 16 Nov 2016 10:00:53 -0500
Message-ID: <wrfjzikzlba2.fsf@redhat.com>
References: <CAPO=kN3xzv_MmbTSLT0bfxOpdZ+yvmybSXb6L-goBUasm+1NoQ@mail.gmail.com>
        <877f86k3we.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f86k3we.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 14 Nov 2016 16:48:49 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Arka Sharma <arka.sw1988@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> On Sun, Nov 13 2016, Arka Sharma wrote:
>
>> Hello All,
>>
>> Is there any tool apart from mdadm available which can create software
>> RAID based on Ddf metadata. We want to dump the metadata content and
>> tally with metadata written by mdadm and our application.
>
> Not that I'm aware of.
> dmraid can read some ddf metadata, but I don't think it will create new
> metadata.

I thought some BIOS code would be able to do it, similar to how Intel's
IMSM BIOS does it?

Jes
