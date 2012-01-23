From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 17:04:08 +0000
Message-ID: <4F1D9308.7040806@anonymous.org.uk>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com> <4F1D89B9.9080802@redhat.com> <4F1D8D27.5070207@redhat.com> <4F1D905C.1050300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1D905C.1050300@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 23/01/2012 16:52, Doug Ledford wrote:
> On 01/23/2012 11:39 AM, Jes Sorensen wrote:
[...]
>> Kay suggested --preroot on irc - would that do the job? I think that is
>> a bit better than --offroot.
>
> I'd say preroot is better than preboot for sure.  I think I still like
> offroot more than preroot though.

For what it's worth, as a moderately experienced user rather than an 
expert like you guys, I'd vote for this - I nearly suggested something 
like this earlier in the thread, but didn't because I thought I must 
have misunderstood, but Doug's explanation has just confirmed that I had 
it right in the first place - the mdmon invoked with --this-new-option 
is started from the initrd, in advance of the real root filesystem being 
mounted, but hangs around until after the real root filesystem has gone 
again, so that for example --postroot would make just as much sense as 
--preroot, and neither is as good as --offroot.

Cheers,

John.

