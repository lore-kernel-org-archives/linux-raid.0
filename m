From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 00/19] More fixes for resource leaks and warnings
Date: Wed, 02 Nov 2011 17:58:18 -0400 (EDT)
Message-ID: <2c65f48a-bc5b-4886-a81e-4a4fcb2b45b5@zmail05.collab.prod.int.phx2.redhat.com>
References: <4EB15620.7090100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB15620.7090100@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

----- Original Message -----
> On 11/02/11 01:25, NeilBrown wrote:
> > Thanks Jes.
> > I've applied all of these - using the second version of patch 19.
> > 
> > I'm not normally very fussed about freeing and closing things
> > shortly before
> > the process is going to exit anyway, but I'm not against it.  And
> > some of
> > your patches were for other leaks.
> 
> Hi Neil,
> 
> I totally agree here. The main reason for applying those fixes is to
> reduce the S/N ratio from the checking tools.

It has the advantage that if mdadm is ever converted to run any of
these routines from a long standing operation (say monitor mode decides
to start doing new things), then we aren't tasked with fixing up
1001 little details that could have been right in the first place ;-)

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

