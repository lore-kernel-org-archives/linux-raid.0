From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 5/8] {platform,super}-intel: Fix two resource leaks
Date: Thu, 10 Mar 2016 11:37:26 -0500
Message-ID: <wrfjr3fi1e7t.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<1457458252-20203-6-git-send-email-Jes.Sorensen@redhat.com>
	<87d1r4lhb8.fsf@notabene.neil.brown.name>
	<wrfjegbjvcvd.fsf@redhat.com> <1457608450.28311.10.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457608450.28311.10.camel@intel.com> (Pawel Baldysiak's message
	of "Thu, 10 Mar 2016 11:14:10 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "gqjiang@suse.com" <gqjiang@suse.com>
List-Id: linux-raid.ids

"Baldysiak, Pawel" <pawel.baldysiak@intel.com> writes:
> On Wed, 2016-03-09 at 11:23 -0500, Jes Sorensen wrote:
>> NeilBrown <neilb@suse.de> writes:
>> >=20
>> > On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:
>> > Returning '1' looks really weird here.=C2=A0=C2=A0I can see it is =
consistent with
>> > 	if (hba->type !=3D SYS_DEV_VMD)
>> > 		return 1;
>> >=20
>> > above, but still....
>> > As the return value is never used, should we just make it 'void' ?=
?
>> Seems reasonable - I'll put that in a separate patch.
>>=20
>> Cheers,
>> Jes
> Hello,
> Thanks for the fix Jes.
>
> I thinks that instead of making it "void" we can actually check the
> return value and print a proper message if something goes wrong.
> Also "simplified for() loop" can be applied to ahci_enumerate_ports()=
 as well.
>
> @@ -1624,7 +1624,10 @@ static int ahci_enumerate_ports(const char
> *hba_path, int port_count, int host_b
> =C2=A0	=C2=A0* this hba
> =C2=A0	=C2=A0*/
> =C2=A0	dir =3D opendir("/sys/dev/block");
> -	for (ent =3D dir ? readdir(dir) : NULL; ent; ent =3D readdir(dir)) =
{
> +	if (!dir)
> +		return 1;
> +
> +	for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
> =C2=A0		int fd;
> =C2=A0		char model[64];
> =C2=A0		char vendor[64];
> @@ -2021,7 +2024,11 @@ static int detail_platform_imsm(int verbose,
> int enumerate_only, char *controlle
> =C2=A0					print_imsm_capability(&entry->orom);
> =C2=A0					printf(" I/O Controller : %s (%s)\n",
> =C2=A0 vmd_domain_to_controller(hba, buf), get_sys_dev_type(hba->type=
));
> -					print_vmd_attached_devs(hba);
> +					if (print_vmd_attached_devs(hba)) {
> +						if (verbose > 0)
> + pr_err("failed to get devices attached to VMD domain.\n");
> +						result |=3D 2;
> +					}
> =C2=A0					printf("\n");
> =C2=A0				}
> =C2=A0			}
>
> Is that ok with you? Should I prepare a proper patch with this?

Hi Pawel,

I already pushed this into git, but if you want to send me a patch (or
two) for this, I am happy to apply them. Lets make the
ahci_enumerate_ports() change in a separate patch.

Cheers,
Jes
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
