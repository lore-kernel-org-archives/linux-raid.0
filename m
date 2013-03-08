From: Joseph Glanville <joseph.glanville@orionvm.com.au>
Subject: Re: [PATCH] MD: Fix typos in MD documentation
Date: Sat, 9 Mar 2013 04:35:16 +1100
Message-ID: <CAOzFzEjA31yo7whp70D4fMiucsaoDJearRUBK5nQ8Ey+rqxZXA@mail.gmail.com>
References: <1362694766.28152.1.camel@f16>
	<1362733923.7193.30.camel@mattotaupa>
	<AE55049E-63BD-4A47-96EB-04B113319571@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AE55049E-63BD-4A47-96EB-04B113319571@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Paul Menzel <pm.debian@googlemail.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 9 March 2013 00:28, Brassow Jonathan <jbrassow@redhat.com> wrote:
>
> On Mar 8, 2013, at 3:12 AM, Paul Menzel wrote:
>
>> Am Donnerstag, den 07.03.2013, 16:19 -0600 schrieb Jonathan Brassow:
>>> MD:  Fix some typos/grammer in MD documentation
>>>
>>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>>>
>>> Index: linux-upstream/Documentation/md.txt
>>> ===================================================================
>>
>> Did you use `git format-patch`? If not, hopefully this patch can be
>> easily applied with `git am`.
>
> No.  I generally use 'quilt' and insert the patches into my email client.  If it's better to do something else, let me know and I will do that.
>
>  brassow
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Take a look at git-format-patch and git-send-email. :)

Generally this is preferred as the patches can be applied
automatically via git-am

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
