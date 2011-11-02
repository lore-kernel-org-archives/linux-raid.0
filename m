From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 00/19] More fixes for resource leaks and warnings
Date: Wed, 02 Nov 2011 15:39:28 +0100
Message-ID: <4EB15620.7090100@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com> <20111102112530.2fd3cb7f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102112530.2fd3cb7f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 11/02/11 01:25, NeilBrown wrote:
> Thanks Jes.
> I've applied all of these - using the second version of patch 19.
> 
> I'm not normally very fussed about freeing and closing things shortly before
> the process is going to exit anyway, but I'm not against it.  And some of
> your patches were for other leaks.

Hi Neil,

I totally agree here. The main reason for applying those fixes is to
reduce the S/N ratio from the checking tools.

With my latest with these patches applied run I got about 65 warnings
whereas I am getting around 105 in the version of mdadm that is in
Fedora 16. Some of these are definitely false positives, but I have
another set of patches with real fixes coming your way shortly.

>> This is the bulk of these for now. Please notice that I haven't
>> touched super-ddf.c at all, and that is probably the single biggest
>> offender. Also note that I haven't addressed a number of warnings in
>> sysfs.c where we know for sure that files aren't bigger than a given
>> size. The tool obviously doesn't know this, so it spews warnings when
>> we strcpy() content we just read. While the code per-ce is probably
>> safe, we may want to switch to strncpy() just to reduce the noise
>> ratio?
> 
> Maybe.  I hate strncpy because it doesn't reliably nul-terminate but I'm
> happy to make the code 'safer' as long as we avoid making it ugly.

I couldn't agree more - it is such a mess :(

Cheers,
Jes
