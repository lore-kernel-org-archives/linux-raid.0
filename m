From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Subject: Re: Was: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Thu, 08 Nov 2007 21:06:48 +1000
Message-ID: <1194520008.17369.19.camel@localhost>
References: <1194084522.1353.10.camel@localhost>
	 <87fxziju0z.fsf@informatik.uni-tuebingen.de>
Reply-To: konstantin.sharlaimov@gmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fxziju0z.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Rik van Riel <riel@redhat.com>, "; Ingo Molnar" <mingo@redhat.com>, "; Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

On Wed, 2007-11-07 at 10:15 +0100, Goswin von Brederlow wrote:
> I wonder if there shouldn't be a way to turn this off (or if there
> already is one).
> 
> Or more generaly an option to say what is "near". Specifically I would
> like to teach the raid1 layer that I have 2 external raid boxes with a
> 16k chunk size. So read/write within a 16k chunk will be the same disk
> but the next 16k are a different disk and "near" doesn't apply
> anymore.

Currently there is no way to turn this feature off (this is only a
"request for comments" patch), but I'm planning to make it configurable
via sysfs and module parameters.

Thanks for suggestion for the "near" definition. What do you think about
adding the "chunk_size" parameter (with the default value of 1 chunk = 1
sector). Setting it to 32 will make all reads within 16k chunk to be
considered "near" (with zero distance) so they will go to the same disk.

Max distance will also be configurable (after this distance the "read"
operation is considered "far" and will go to randomly chosen disk)

Regards,
Konstantin

