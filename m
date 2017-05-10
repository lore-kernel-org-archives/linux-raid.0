From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: Fault tolerance with badblocks
Date: Wed, 10 May 2017 11:44:46 -0500
Message-ID: <CACsGCyQGoR_9dr7aYGZn1i2VWm8KWKgi1fy2x6met=UePw2OQw@mail.gmail.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk>
 <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
 <59121C1C.1050101@youngman.org.uk> <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 9, 2017 at 10:53 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Scrubs don't happen by default.

From the perspective of Linux Raid authors, that is true.  However,
the version of Fedora I have installed on my server at home does
weekly scrubs by default.  This is arguably a good thing, considering
that many people installing this OS will not proactively research the
technologies in use holding their server together and won't know that
there are certain maintenance activities that are essential if you
care about your data.

I'm not getting involved in the bigger discussion.  My opinion is too
uninformed to say anything there.  I just wanted to point out that
*from the viewpoint of some users*, scrubs *will* happen by default.
That is all.

            Eddie
