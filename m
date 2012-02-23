From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Use MDMON_DIR for pid files created in Monitor.c
Date: Thu, 23 Feb 2012 21:47:32 +0100
Message-ID: <4F46A5E4.3030900@redhat.com>
References: <1328183102-9377-1-git-send-email-Jes.Sorensen@redhat.com> <CAGqmV7o1G86SPn4vM-LuXtKr9-gi=boVMNJzBP93komSLsHEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7o1G86SPn4vM-LuXtKr9-gi=boVMNJzBP93komSLsHEWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/23/12 21:39, CoolCold wrote:
> On Thu, Feb 2, 2012 at 3:45 PM,  <Jes.Sorensen@redhat.com> wrote:
>> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> >
>> > Other parts of mdadm/mdmon place .pid/.sock files in MDMON_DIR. This
>> > makes Monitor.c consistent with the rest.
>> >
>> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> > ---
>> >  Monitor.c |    8 +++++---
>> >  1 files changed, 5 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/Monitor.c b/Monitor.c
>> > index 77f22aa..7ed5282 100644
>> > --- a/Monitor.c
>> > +++ b/Monitor.c
>> > @@ -294,8 +294,10 @@ static int check_one_sharer(int scan)
>> >        int pid, rv;
>> >        FILE *fp;
>> >        char dir[20];
>> > +       char path[100];
> Just wondering why not something like PATH_MAX or similar constant? I
> guess there should be one, though 100 should be enough

I used 100 here because it was consistent with how it is handled
elsewhere in the code. Having a constant would be fine with me, as long
as it is applied consistently.

Jes
