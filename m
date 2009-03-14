From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Track raid5/6 statistics
Date: Sat, 14 Mar 2009 10:07:49 -0700
Message-ID: <e9c3a7c20903141007h5fea439co70e4ea9ea4a10ec1@mail.gmail.com>
References: <20090312205754.GH8732@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090312205754.GH8732@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Mar 12, 2009 at 1:57 PM, Jody McIntyre <scjody@sun.com> wrote:
> This patch tracks various statistics related to the performance of a =
RAID 5
> or 6 array. =A0These have been useful to us in the past to help solve
> performance issues. =A0They are reported via the 'stat' file in each =
device's
> 'md' sysfs directory, e.g. /sys/class/block/md0/md/stat .
>
> A slight amount of overhead is added by the atomic_inc() and atomic_d=
ec()
> calls used in these patches, but it's so low I've been unable to meas=
ure it.
> Both calls are already used extensively in raid5.c to track internal
> counters so I believe this is OK.
>

Hi Jody,

I am curious, can you say a bit more about the performance problems
you solved with this data?  Is there a corresponding userspace tool
that interprets these numbers?  My earlier recommendation to use some
type of tracepoint had more to do with the fact that the data could be
interpreted by existing tools rather than the overhead.  Looking a bit
closer at the statistics it seems most are currently available via
/proc/diskstats and blktrace...

[..]
> +static ssize_t
> +stat_show(mddev_t *mddev, char *page)
> +{
> + =A0 =A0 =A0 raid5_conf_t *conf =3D mddev_to_conf(mddev);
> + =A0 =A0 =A0 if (conf)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return sprintf(page, "%u %u %u %u %u %u=
 %u %u %u %u %u %u %u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->reads_in),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->writes_in),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->reads_out),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->writes_out),

=2E..available in /proc/diskstats and blktrace.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->reads_for_rmw),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->reads_for_rcw),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->aligned_reads),

=2E..these could be useful as there is no other way to retrieve this in=
formation.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->active_stripes),

=2E..duplicate of stripe_cache_active attribute

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->in_reqs_in_queue),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->out_reqs_in_queue),

=2E..available via blktrace

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->delayed),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->bit_delayed),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_r=
ead(&conf->out_of_stripes));

=2E..these could be useful

So, my original suggestion/question should have been why not extend
blktrace to understand these incremental MD events?

Regards,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
