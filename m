From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 7/7] md: add bcache personality
Date: Fri, 18 May 2012 09:57:36 -0700
Message-ID: <CABE8wws5HiNoQbCmEh7Qai=RwbGg4CencgQe6g6f=9=+tb=QaQ@mail.gmail.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
	<20120511194647.25770.88687.stgit@dwillia2-linux.jf.intel.com>
	<4FB67E4B.6000204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB67E4B.6000204@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: neilb@suse.de, koverstreet@google.com, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 18, 2012 at 9:52 AM, Doug Ledford <dledford@redhat.com> wro=
te:
> On 5/11/2012 3:46 PM, Dan Williams wrote:
>> "Backing
>> device" vs "cache device" is determined by slot number whereby the
>> backing device slot is the highest number index.
>
> That needs fixing. =A0We used to do things by slot number long ago, a=
nd it
> turned out to create lots of races on reconfiguring slot indexes and
> moving devices around on rebuilds and stuff like that. =A0I would hav=
e to
> see us undo that fix when it comes to bcache.

Yeah, that hack should be easy to remove and userspace can look at the
sysfs attributes to determine the device's role.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
