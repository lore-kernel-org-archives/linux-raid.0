From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2] md/raid0: add config parameters to specify zone layout
Date: Fri, 24 Apr 2020 23:22:23 +0000
Message-ID: <81A991E8-B87E-4518-9643-45037A104981@fb.com>
References: <1585584045-11263-1-git-send-email-jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1585584045-11263-1-git-send-email-jbaron@akamai.com>
Content-Language: en-US
Content-ID: <14A498177D9406408AB7D323A41B5F7D@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: "rdunlap@infradead.org" <rdunlap@infradead.org>, "neilb@suse.de" <neilb@suse.de>, "guoqing.jiang@cloud.ionos.com" <guoqing.jiang@cloud.ionos.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids



> On Mar 30, 2020, at 9:00 AM, Jason Baron <jbaron@akamai.com> wrote:
>=20
> Let's add some CONFIG_* options to directly configure the raid0 layout
> if you know in advance how your raid0 array was created. This can be
> simpler than having to manage module or kernel command-line parameters.
>=20
> If the raid0 array was created by a pre-3.14 kernel, use
> RAID0_ORIG_LAYOUT. If the raid0 array was created by a 3.14 or newer
> kernel then select RAID0_ALT_MULTIZONE_LAYOUT. Otherwise, the default
> setting is RAID0_LAYOUT_NONE, in which case the current behavior of
> needing to specify a module parameter raid0.default_layout=3D1|2 is
> preserved.
>=20
> Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Jason Baron <jbaron@akamai.com>

This patch looks good. However, I am not sure whether the user will=20
recompile the kernel for a different default value. Do you have real
world use case for this?

Thanks,
Song
