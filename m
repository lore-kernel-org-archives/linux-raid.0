Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F741149C7F
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 13:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714139958; cv=none; b=udficFi42bWSRml2ITiJMDXWcMNdNzD0NauXJKyocrreyOd6+Rr1a4EaHS8ZV/y/a96kqCUyif3Avjj0PJ+gyb+XjoA+Afb3Jee2VLzoKmpLJAqh7UoaJ9v3rsUqoWdzf03Rc2ypnSyKRcm5gTe3RIdpRfdAQJrJCFvI5rgj260=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714139958; c=relaxed/simple;
	bh=unFM6L43NXBWnHJ8dIDsoy+n9eaUzzkAO6Gxel9aId0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQABuCqMd1XHo6XYYlbOJt2REmpNzhQySYyguFS6oBZ+EkB6QPIIkQeWueThva3WayFZM0ZmnLUVhV7CehJmIgNoClTQkZp71RQviVM0R11WEiEmgI3Ci7jhSGwzWq1wfUs1WFW+oaB0+9RdLFieHjE0w4Grx/65SWecOWDObMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rf1upYor; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rf1upYor"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714139957; x=1745675957;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=unFM6L43NXBWnHJ8dIDsoy+n9eaUzzkAO6Gxel9aId0=;
  b=Rf1upYorUS7AFiX65QWTm5jRy1LONoE2/KLYCq+M+/m/qt1HYj/tvq2d
   j+QmUSLtlibllKS42nyvpQAiCGD9JjbtggF8OlmXAcw4yrX1f8wOg++e7
   2IwXwT4uNMQssFtOFCkJQ5CV6km7G8366/5ggIRslIcH2VEGocJ3Z9Tlz
   M3HuC0LoES2cImFK7fq73P90vruH8UgjOcaNPiEdclgo31J9r0jr3rU1E
   /HttVhVJg+7aHxNmMh/6MiCcrsE4OcwhdHwuf4RRydt8ZINElth/wU6ug
   MwcGps+eEV2kMboyyVh7BazWcWLMA6n2OwkdRG/SDKdQdKlIOP2rilVN/
   Q==;
X-CSE-ConnectionGUID: kQQYfOpYTcm2ijYQ5od7jw==
X-CSE-MsgGUID: 2ZL0+Ll8RzqFddo/TyI3jA==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="9735854"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9735854"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 06:59:16 -0700
X-CSE-ConnectionGUID: 2pK947htQuiWLrwLvNHl9g==
X-CSE-MsgGUID: 0OvChX3WRlCNhDAqMK5v2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="48655025"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 06:59:14 -0700
Date: Fri, 26 Apr 2024 15:59:09 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>,
 Kinga Tanska <kinga.tanska@linux.intel.com>, Jes Sorensen
 <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/1] Move mdadm development to Github
Message-ID: <20240426155909.00007ac2@linux.intel.com>
In-Reply-To: <8cb179cf-3c11-4ef0-99ad-a704d856283e@molgen.mpg.de>
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
	<f8044311-765d-4743-8b20-0d68a56044ec@molgen.mpg.de>
	<20240426103640.0000549e@linux.intel.com>
	<8cb179cf-3c11-4ef0-99ad-a704d856283e@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Paul,
I will disable "Discussions" panel on Github. That make sense to ask people=
 to
direct question to ML. I will try to keep "Issues" related to mdadm only.
Otherwise we will redirect people to ML. For example, in case when someone =
is
looking for help how to recover array it should be directed to ML not Githu=
b.

I think that sending notification about new pull request will be enough for
interested folks to take a look and eventually comment. So I still would li=
ke
to do review outside ML but if there is a need to consult feature/bugfix it=
 can
be sent to ML as RFC to get wider community support.

It is not one way move, we have to do what is reasonable and necessary for
mdadm to grow. It is not that we are moving to github and abandoning ML. It=
 is
and always will be a part of mdadm and can be used if needed.

More detailed answers below.
Thanks,
Mariusz

On Fri, 26 Apr 2024 11:52:05 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Mariusz,
>=20
>=20
> Thank you for your quick reply.
>=20
> Am 26.04.24 um 10:36 schrieb Mariusz Tkaczyk:
> > On Fri, 26 Apr 2024 08:46:18 +0200 Paul Menzel wrote: =20
>=20
> >> Thank for bringing this topic up for discussion. Unfortunately, I have
> >> to reply with negative comments.
> >>
> >> Am 19.04.24 um 03:48 schrieb Mariusz Tkaczyk: =20
> >>> Thanks to Song and Paul, we created organization for md-raid on Githu=
b.
> >>> This is a perfect place to maintain mdadm. I would like announce movi=
ng
> >>> mdadm development to Github.
> >>>
> >>> It is already forked, feel free to explore:
> >>> https://github.com/md-raid-utilities/mdadm
> >>>
> >>> Github is powerful and it has well integrated CI. On the repo, you can
> >>> already find a pull request which will add compilation and code style
> >>> tests (Thanks to Kinga!).
> >>> This is MORE than we have now so I believe that with the change mdadm
> >>> stability and code quality will be increased. The participating method
> >>> will be simplified, it is really easy to create pull request. Also,
> >>> anyone can fork repo with base tests included and properly configured.
> >>>
> >>> Note that Song and Paul are working on a per patch CI system using Gi=
tHub
> >>> Actions and a dedicated rack of servers to enable fast container, VM =
and
> >>> bare metal testing for both mdraid and mdadm. Having mdadm on GitHub =
will
> >>> help with that integration. =20
> >>
> >> Improved testing sounds good. Thank you. I do not think though, that
> >> using GitHub is a requirement for that, and there are a lot of bots on
> >> the Linux kernel mailing list doing this without GitHub. =20
>=20
> > At some point Paul Luse and Song Liu decided that they will choose Gith=
ub
> > for MD CI and Paul is busy working on creating dedicated Github runners=
 for
> > MD CI. Moving mdadm development then is a logical next step as I want to
> > reuse the prepared hardware resources simple way.
> >  =20
> >>> As a result of moving to GitHub, we will no longer be using mailing l=
ist
> >>> to propose patches, we will be using GitHub Pull Requests (PRs). As t=
he
> >>> community adjusts to using PRs I will be setting up auto-notification
> >>> for those who attempt to use email for patches to let them know that =
we
> >>> now use PRs.  I will also setup GitHub to send email to the mailing l=
ist
> >>> on each new PR so that everyone is still aware of pending patches via
> >>> the mailing list. =20
> >>
> >> In my experience, using GitHub for code review is far inferior to using
> >> mailing lists or Gerrit. First, you cannot comment on the commit
> >> message. As a result, projects using GitHub have a really low-quality
> >> git history. Also, you only cannot comment single parts of a line in t=
he
> >> diff. =20
> >=20
> > These are known limitations. I understand your objections here. =20
>=20
> It would be nice, if you listed them in your proposal with solutions how=
=20
> to address them. That would have avoided them.

This particular problem (commit messages quality) must be addressed by revi=
ew
process itself so nothing fancy to list. We are responsible for the commits
which are comes to repository, wherever they are reviewed. At minimal,
checkpatch action will be done on each commit in PR, you can see it proposed
here:
https://github.com/md-raid-utilities/mdadm/pull/2

For the Github review GUI limitations, we have to accept them. It will be
reviewer task to make comment clear to help author move this forward. You c=
an
copy part of the commit message to comment and add link to it and say what =
you
want. Github has nice markdown support reviewer should use it to make it ea=
sier
to follow. For example, this is my comment in different project:
https://github.com/intel/ledmon/pull/193#issuecomment-1941462964
Isn't it clear?

>=20
> > We have to accept them. =20
>=20
> I do not think so. Why?

Because I think that what Github offers if enough to develop mdadm.
I don't want to reinvent the wheel because we sticked to different work
model. As I want to take this step I'm going to take what makes sense, what
gives a value and what makes developer participation easier.

That should work for 90% of patches. If we are in doubts we can always send=
 RFC
to ML to get support.

>=20
> > Commits will be as good as maintainers cares about them. Please keep
> > in mind that except Intel, the activity around mdadm is low. I'm
> > receiving 1 patchset within 2 weeks. I can deal with those
> > limitations and I don't need customized and advanced solution with
> > huge maintenance cost (at least for now). If that will be changed- we
> > will propose something else. =20
> If it is that low, then I do not understand, why the infrastructure=20
> needs to be changed at all.

Because we want to add real CI testing and avoid maintaining it. We will ha=
ve
just Github, nothing more than that. Simple development process, everyone c=
an
contribute. It does not require to be familiarized with ML in standard cases
(for example to fix compilation issue).

>=20
> > There are many Github actions we can setup to help us with review. =20
>=20
> Can you please give example projects, that have implemented that on GitHu=
b?

https://github.com/md-raid-utilities/mdadm/pull/2
Above you have pull to mdadm which provides base testing:
- default gcc checks with various CXFLAGS
- checkpatch checks
Next, real tests will be added (we will start with enabling mdadm tests) bu=
t to
make that we need custom GH runners.

You can see well developed checks in dracut project:
https://github.com/dracutdevs/dracut/pull/2643/checks

>=20
> >> The =E2=80=9Cone thread=E2=80=9D discussion model is also a pain, as m=
ost people using
> >> Web forms do not correctly cite and quote, and with more than three
> >> answers you loose the overview. For some reason people think more about
> >> their reply, using mailing lists than Web forms. =20
> >=20
> > We cannot ban less experienced users from participating. I want to make
> > mdadm development more attractive. I know that generally folks here are=
 well
> > experienced in Linux netiquette, having github will change that. =20
>=20
> Has this claim ever been proven, now that a lot of projects made the=20
> switch. Did participation actually increase?

For sure moving ledmon from sourceforge to github increased its visibility.=
 I
know because I was in the team at this time:
https://github.com/intel/ledmon

However, I'm not sure if that is example you are looking for. I think that
dracut matches better here. You can see that development on github is really
active but I don't know how it was in the past. For sure, it didn't kill dr=
acut.
https://github.com/dracutdevs/dracut

>=20
> > It is another trade-off I agree to take.
> >  =20
> >> Using different forums for discussions should also not be allowed.
> >> People should just subscribe and monitor one forum. =20
> >=20
> > For young developers Github is natural work environment. If they want
> > to to file issue (as they do for thousand other projects) - they can.
> > If github mdadm maintainers cannot support them, we will redirect
> > them to mailing list for wider audience. =20
> As written, I do not think splitting forums (for a small project) is a=20
> good idea.

On github I can enable issues, discussions and wiki tabs. I can also create
dedicated github.io site:
https://pages.github.com/

This all waiting and we can use that but we don't have to. I totally agree =
now
that it is better to keep discussions and support in one source, so here is=
 my
proposal:
- issues will be used to report bugs for mdadm. *For bugs*, not for reaching
  help with failed scenarios, suggestions etc.
- discussions - I will disable it because it should take place on ML.
- wiki - we have raid wiki so for now I will disable it, unless we would li=
ke
  to start noting some mdadm related information (know issues in mdadm, low
  level tasks for new developers to participate, how to compile,
  development tricks etc.) only mdadm development related things.

Anything else, goto ML.

What do you think? Can it work?

>=20
> >> So, I strongly oppose this move, but I am also aware, that I am not
> >> doing a lot of development contribution. =20
> >=20
> > The truth is that mdadm is a small and "simple" userspace project.
> > There is not a tons of development around it. Please help me keep
> > simple things simple. =20
> As written above, if that is true, I do not understand the effort put=20
> into changing the infrastructure. The effort could have gone into=20
> writing the CI infrastructure for a mailing list process. Other Intel=20
> departments seem to do it already, so work would not need to be reinvente=
d?

Are you asking about lkp@intel.com kernel test robot? This robot is kernel =
only
- I asked them in the past.

I think that Paul Luse can comment here more but I think that removing mdadm
patches from ML will make an effort of creating CI for MD simpler because
there will be no patches related to other project, kernel only.

Whatever requires maintenance on any side increases complexity and I think =
that
mdadm is not enough big to increase complexity. We can just use github only=
 and
reuse runners, initially created for MD testing. Any script, or daemon work=
ing
in background must be hosted somewhere (and someone needs to care
about it). I don't want that because I think that it is not necessary.

>=20
> > We can achieve CI, (probably) "sufficient" review system and
> > simplified well known on market participating process in few clicks.
> > Maintenance of review solution will not belong to us (expect custom
> > GH runners). =20
>=20
> Sorry, I do not understand.

I meant that on Github we can simply achieve review and CI systems with no
additional work. The one change is only where mdadm patches are sent.

=46rom developer perspective Github workflow is easier.

>=20
> > For these reasons, I see it a natural next step to grow but I'm also
> > familiar with Github limitations. I have to deal with them in other
> > projects I'm maintaining or participating. =20
>=20
> I am not convinced the theoretical more participants are outweighing the=
=20
> cost for the existing folks being happy with the current infrastructure.

You and I are reviewers of mdadm patches mainly. Comments from other people=
 are
sporadic. Thank you for all work but it is not enough. I need to try buildi=
ng
mdadm developers community and here we are shadow of MD.

Mdadm has other problems, people here are rarely interested in fixing them.

But still some RFC's for mdadm would be send here - we can always request t=
hat
on Github. As a reviewers we need to ensure that the change is good so if w=
e are
not sure, reaching mailing list would be crucial.

Does it work for you?

>=20
> > I also know that I can count of support from Linux Foundation in case
> > of special needs (like additional resources). That is also great. =20
>=20
> Sorry, I also do not understand this statement. Is the Linux Foundation=20
> only supporting projects using a GitHub based workflow?
>=20

No, I meant that if there will be a need to they can help me reach Microsof=
t to
get more resources, but since we have create make our own runners then prob=
ably
this point has no sense. Sorry!

Thanks,
Mariusz
