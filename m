From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
Date: Thu, 19 Mar 2009 10:08:59 -0700
Message-ID: <e9c3a7c20903191008y5262a991ufefd17254075c977@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <87ljr21jo4.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljr21jo4.fsf@basil.nowhere.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

On Wed, Mar 18, 2009 at 4:43 PM, Andi Kleen <andi@firstfloor.org> wrote=
:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> This series constitutes the pieces of the raid6 acceleration work th=
at are
>> aimed at the next merge window. =A0It implements:
>> 1/ An api for asynchronous raid6 parity generation and recovery rout=
ines
>
> Could you please comment a bit how well the default load balancing wo=
rks. If
> I write a single stream from a single CPU will it use multiple CPU
> cores in the system to do the RAID6 work?

No, that is an item for the todo list.  This implementation is only
asynchronous when a raid6 hardware offload resource is available, when
this is not the case it runs synchronous/single-threaded.  In general
the api is meant to inherit the load balancing of the caller.  For
md/raid6 this is currently always single threaded for writes and
degraded reads regardless of the number of requesting threads.

This work does make some progress towards multithreaded raid6 in that
calculations can now be preempted (i.e. no longer performed under the
stripe spin_lock).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
