From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] md/raid5: Use correct IS_ERR() variation on pointer check
Date: Mon, 09 Jan 2017 16:38:28 -0500
Message-ID: <wrfjziizrk17.fsf@redhat.com>
References: <20170107003135.8276-1-Jes.Sorensen@redhat.com>
        <20170107003135.8276-2-Jes.Sorensen@redhat.com>
        <20170109213412.we7sxcivzbaiyb3i@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170109213412.we7sxcivzbaiyb3i@kernel.org> (Shaohua Li's
        message of "Mon, 9 Jan 2017 13:34:12 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaohua Li <shli@kernel.org> writes:
> On Fri, Jan 06, 2017 at 07:31:35PM -0500, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> This fixes a build error on certain architectures, such as ppc64.
>
> Yep, we should use IS_ERR here, applied this. I'm curious why there is a
> compile error. The IS_ERR_VALUE casts the pointer to 'unsigned long'.

When building on ppc64 I get a -Wsign-compare build error due to -Werror.

Cheers,
Jes
