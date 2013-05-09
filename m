From: Dusty Mabe <dustymabe@gmail.com>
Subject: Re: 0.90 vs 1.X - Differing behavior for device # during
 fail/remove/add operation
Date: Thu, 9 May 2013 11:30:26 -0400
Message-ID: <CAFfJ-R6Fgz+Mye2FX5D-+uaM0jgUe2j4nnE1ACyCwwk=9X-KPQ@mail.gmail.com>
References: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Dusty Mabe <dustymabe@gmail.com>
List-Id: linux-raid.ids

On Wed, May 8, 2013 at 1:39 PM, Dusty Mabe <dustymabe@gmail.com> wrote:
> CentOS 6.3
> 2.6.32-279.19.1
> mdadm-3.2.3-9.el6.x86_64
>
>
> I have noticed that the device number printed in the mdstat file gets
> changed if you fail->remove->add a member device of a 1.X metadata
> array, but for a 0.90 metadata array the device will go back to the
> original value once recovery has finished.
>
>
> Is this by design? I know 1.X version of metadata use dev_roles rather
> than this_disk and the mdp_disk_t structure so maybe it is by design?
>

Hey guys.. Sorry to be a pain. Has anyone seen this before? Is it by
design or a known issue?

Dusty
