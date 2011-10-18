From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/1] IMSM do not assume prev + current map in same state
 means reshape
Date: Tue, 18 Oct 2011 07:09:32 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A040217@IRSMSX101.ger.corp.intel.com>
References: <1318884015-14749-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1318884015-14749-1-git-send-email-Jes.Sorensen@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "dledford@redhat.com" <dledford@redhat.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Jes.Sorensen@redhat.com [mailto:Jes.Sorensen@redhat.com]
> Sent: Monday, October 17, 2011 10:40 PM
> To: linux-raid@vger.kernel.org
> Cc: neilb@suse.de; dledford@redhat.com; Dorau, Lukasz; Kwolek, Adam;
> Labun, Marcin
> Subject: [PATCH 0/1] IMSM do not assume prev + current map in same state
> means reshape
> 
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Hi,
> 
> I believe there is a bug in the current IMSM code. It makes the assumption
> that if the state of the previous map and the current map are the same, it
> means we are trying to reshape the array. However if you have a large array
> and just installed on it, and it was still resyncing when you rebooted, it will
> come up in the same state and 'mdadm -Aa' will fail with an error that it is
> lacking a resync file.
> 
> This is what prevents an update Fedora 15 system from booting, such as
> https://bugzilla.redhat.com/show_bug.cgi?id=736387
> 
> If I am missing something here, I'd appreciate to hear about it.
> 
> Thanks,
> Jes


Hi,
There is bug there as you pointed in your email, but it is already fixed in Neil's repository by commit :
	imsm: fix: stopped resync does not continue after auto-assemblation
	b601104eb4a4733a838fb86e9e279fed14ce9d3f

Your patch "IMSM do not assume prev + current map in same state means reshape" can break
e.g chunk size migration when number of disks doesn't change. 

Correct fix is pointed above and it tests migration type.

BR
Adam


> 
> Jes Sorensen (1):
>   IMSM only run reshape if number of disks has changed
> 
>  super-intel.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> --
> 1.7.6.4

