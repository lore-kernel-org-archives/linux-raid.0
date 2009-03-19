From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF
	multiplication
Date: Thu, 19 Mar 2009 10:20:19 -0700
Message-ID: <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760007AbZCSRUg@vger.kernel.org>
In-Reply-To: <49C26D91.10804@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Thu, Mar 19, 2009 at 9:06 AM, H. Peter Anvin <h.peter.anvin@intel.co=
m> wrote:
> Dan Williams wrote:
>> + * @scfs: array of source coefficients used in GF-multiplication
>
> Array of source coefficients? =A0Are you doing a vector-vector
> multiplication here?
>
> Given this code:
>
>> =A0 =A0 =A0 for (d =3D 0; d < len; d++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 wq =3D wp =3D ptrs[0][d];
>> + =A0 =A0 =A0 =A0 =A0 =A0 for (z =3D 1; z < src_cnt; z++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wd =3D ptrs[z][d];
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wp ^=3D wd;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wq ^=3D raid6_gfmul[scfs[z=
]][wd];
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> ... it kinds of looks like that.
>
> This is really quite expensive! =A0The whole point of the restore cod=
e
> that exists is that we never do a two-dimensional lookup, instead
> caching a pointer to the multiplication table that we intend to use,
> because the RAID-6 code only ever contains scalar-vector multiplicati=
ons.
>
> I really don't get this, and I think it's broken.

Something is broken if we take this path.  This routine could stand to
have a WARN_ONCE(), because if it is ever called there is something is
wrong with the raid6 offload driver.  The intent is that the
asynchronous recovery routines will perform an early check to see if
the recovery can be offloaded (with a series of calls to
async_xor/async_pq).  If not we fall back to the optimized synchronous
recovery routines (raid6_2data_recov, raid6_datap_recov).  The only
time this path will be taken is if we have decided to perform
asynchronous recovery but at a later call to async_pq the offload
driver reports it has run out of descriptors.

--
Dan
