From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/6] md-cluster: Protect communication with mutexes
Date: Fri, 13 Nov 2015 08:59:08 +1100
Message-ID: <87fv0ariab.fsf@notabene.neil.brown.name>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de> <87mvumsqbp.fsf@notabene.neil.brown.name> <5641631F.2080000@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5641631F.2080000@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10 2015, Goldwyn Rodrigues wrote:

> On 11/09/2015 05:31 PM, NeilBrown wrote:
>> On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:
>>
>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>
>>> Communication can happen through multiple threads. It is possible that
>>> one thread steps over another threads sequence. So, we use mutexes to
>>> protect both the send and receive sequences.
>>>
>>> We use a new flag CLUSTER_MD_COMM_LOCKED which is used to detect
>>> if communication is already locked. This is useful for cases where we n=
eed to
>>> take and hold the token DLM lock for a while. This bit is set only
>>> after locking communication.
>>
>> I don't understand what this flag is trying to achieve, but I'm fairly
>> sure it doesn't achieve it.
>
> Lets consider three specific cases of locking communication channels to=20
> show the conflict:
>
> 1. resync_info_update(): communication is locked and release for sending=
=20
> a message.
> 2. A regular md_update_sb(): communication is locked in=20
> metadata_update_start() and unlocked in metadata_update_finish() after=20
> writing to disk. In metadata_update_finish(), the sendmsg is called to=20
> send METADATA_UPDATED.
> 3. An add operation which culminates in a md_update_sb(): Here the=20
> communication is locked before initiating add. If the add is successful,=
=20
> it results in md_update_sb(). In md_update_sb(), metadata_update_start()=
=20
> has to check if the communication is already locked. If locked, it=20
> should not lock again.

Oh, I get it now - thanks.

Going back and looking at the original commit I can now see that it does
say that, but I didn't understand the implication at the time.

I might be wrong again, but I think this approach is broken.
The 'add disk' sequence does:
  1/ ->add_new_disk which takes the lock
  2/ other stuff, protected by the lock
  3/ schedule a metadata update
  4/ metadata update is initiated, which doesn't take the lock
        because the flag is set
  5/ metadata update completes, lock is dropped.

What if some other event causes the metadata update to happen during
'2'?

Maybe if you delayed setting MD_CLUSTER_COMM_LOCKED until after '2'.
i.e. set it when scheduling the update.  So the flag means:
  "lock has been taken for metadata update"

One tricky bit there would be if metadata_update_start() found the bit
wasn't set, and then entered mutex_lock() in lock_comm().
When MD_CLUSTER_COMM_LOCKED gets set we want that code to stop waiting
and start doing useful things.  But it won't.


It might be easiest to make our own 'mutex' with a flag bit and a wait
queue.

Then calls to mutex_lock become
 wait_event(mddev->wait, !test_and_set_bit(bit, &cinfo->state));
mutex_unlock becoems
 clear_bit(bit, &cinfo->state);

and the mutex_lock used from metadata_update_start is
  wait_event(mddev->wait, !test_and_set_bit(bit, &cinfo->state) ||
                          test_and_clear_bit(MD_CLUSTER_COMM_LOCKED,
  ....));

That might work.... providing it is well documented.

(and you are right - mutex_trylock wouldn't have helped, I was
completely misunderstanding).

Thanks,
NeilBrown



>
> The flag is used only for case 3. If the communication is already=20
> locked, it should not lock again. This flag is set only after=20
> lock_comm() has executed, but is checked for in metadata_update_start().=
=20
> This should insure that any of the operations 1, 2 or 3 do not interfere=
=20
> with each other.
>
> I am not sure if I have made the best effort to explain this. I had a=20
> tough time getting it right (which may or may not be complete).
>
>>
>> Maybe if it was test_and_set_bit in metadata_update_start, it might make
>> sense.  But then I would suggest that clearing the bit be moved to
>> unlock_comm()
>>
>> Do you just want to use mutex_try_lock() to detect if communication is
>> already locked?
>
> Consider a race between md_update_sb() and sendmsg() [Case 1. and 2]
>
> mutex_try_lock() may not work in this situation because lock_comm()=20
> could have been called by sendmsg(), which will release it as soon as=20
> the message is sent. In the meantime (while the lock is locked), if a=20
> metadata_update_sb() operation executes. It will not relock the=20
> communication. This will result in the WARN_ON in unlock_comm() since=20
> sendmsg() sequence had already unlocked it.
>
>
>>
>>>
>>> Also, Remove stray/ununsed sb_mutex.
>>
>> I already removed that it mainline - I should have mentioned.
>>
>> Thanks,
>> NeilBrown
>>
>>
>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> ---
>>>   drivers/md/md-cluster.c | 26 +++++++++++++++++++++-----
>>>   1 file changed, 21 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index b73729b..a93734e 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -47,6 +47,7 @@ struct resync_info {
>>>   #define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
>>>   #define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
>>>   #define		MD_CLUSTER_BEGIN_JOIN_CLUSTER		3
>>> +#define		MD_CLUSTER_COMM_LOCKED			4
>>>
>>>
>>>   struct md_cluster_info {
>>> @@ -54,7 +55,8 @@ struct md_cluster_info {
>>>   	dlm_lockspace_t *lockspace;
>>>   	int slot_number;
>>>   	struct completion completion;
>>> -	struct mutex sb_mutex;
>>> +	struct mutex recv_mutex;
>>> +	struct mutex send_mutex;
>>>   	struct dlm_lock_resource *bitmap_lockres;
>>>   	struct dlm_lock_resource *resync_lockres;
>>>   	struct list_head suspend_list;
>>> @@ -503,6 +505,7 @@ static void recv_daemon(struct md_thread *thread)
>>>   	struct cluster_msg msg;
>>>   	int ret;
>>>
>>> +	mutex_lock(&cinfo->recv_mutex);
>>>   	/*get CR on Message*/
>>>   	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
>>>   		pr_err("md/raid1:failed to get CR on MESSAGE\n");
>>> @@ -529,6 +532,7 @@ static void recv_daemon(struct md_thread *thread)
>>>   	ret =3D dlm_unlock_sync(message_lockres);
>>>   	if (unlikely(ret !=3D 0))
>>>   		pr_info("unlock msg failed return %d\n", ret);
>>> +	mutex_unlock(&cinfo->recv_mutex);
>>>   }
>>>
>>>   /* lock_comm()
>>> @@ -542,20 +546,22 @@ static int lock_comm(struct md_cluster_info *cinf=
o)
>>>   {
>>>   	int error;
>>>
>>> -	if (cinfo->token_lockres->mode =3D=3D DLM_LOCK_EX)
>>> -		return 0;
>>> +	mutex_lock(&cinfo->send_mutex);
>>>
>>>   	error =3D dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
>>>   	if (error)
>>>   		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
>>>   				__func__, __LINE__, error);
>>> +	mutex_lock(&cinfo->recv_mutex);
>>>   	return error;
>>>   }
>>>
>>>   static void unlock_comm(struct md_cluster_info *cinfo)
>>>   {
>>>   	WARN_ON(cinfo->token_lockres->mode !=3D DLM_LOCK_EX);
>>> +	mutex_unlock(&cinfo->recv_mutex);
>>>   	dlm_unlock_sync(cinfo->token_lockres);
>>> +	mutex_unlock(&cinfo->send_mutex);
>>>   }
>>>
>>>   /* __sendmsg()
>>> @@ -709,7 +715,8 @@ static int join(struct mddev *mddev, int nodes)
>>>   	init_completion(&cinfo->completion);
>>>   	set_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
>>>
>>> -	mutex_init(&cinfo->sb_mutex);
>>> +	mutex_init(&cinfo->send_mutex);
>>> +	mutex_init(&cinfo->recv_mutex);
>>>   	mddev->cluster_info =3D cinfo;
>>>
>>>   	memset(str, 0, 64);
>>> @@ -839,7 +846,12 @@ static int slot_number(struct mddev *mddev)
>>>
>>>   static int metadata_update_start(struct mddev *mddev)
>>>   {
>>> -	return lock_comm(mddev->cluster_info);
>>> +	struct md_cluster_info *cinfo =3D mddev->cluster_info;
>>> +	int ret;
>>> +	if (test_and_clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state))
>>> +		return 0;
>>> +	ret =3D lock_comm(cinfo);
>>> +	return ret;
>>>   }
>>>
>>>   static int metadata_update_finish(struct mddev *mddev)
>>> @@ -864,6 +876,7 @@ static int metadata_update_finish(struct mddev *mdd=
ev)
>>>   		ret =3D __sendmsg(cinfo, &cmsg);
>>>   	} else
>>>   		pr_warn("md-cluster: No good device id found to send\n");
>>> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>>   	unlock_comm(cinfo);
>>>   	return ret;
>>>   }
>>> @@ -871,6 +884,7 @@ static int metadata_update_finish(struct mddev *mdd=
ev)
>>>   static void metadata_update_cancel(struct mddev *mddev)
>>>   {
>>>   	struct md_cluster_info *cinfo =3D mddev->cluster_info;
>>> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>>   	unlock_comm(cinfo);
>>>   }
>>>
>>> @@ -945,6 +959,7 @@ static int add_new_disk(struct mddev *mddev, struct=
 md_rdev *rdev)
>>>   	memcpy(cmsg.uuid, uuid, 16);
>>>   	cmsg.raid_slot =3D cpu_to_le32(rdev->desc_nr);
>>>   	lock_comm(cinfo);
>>> +	set_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>>   	ret =3D __sendmsg(cinfo, &cmsg);
>>>   	if (ret)
>>>   		return ret;
>>> @@ -964,6 +979,7 @@ static int add_new_disk(struct mddev *mddev, struct=
 md_rdev *rdev)
>>>   static void add_new_disk_cancel(struct mddev *mddev)
>>>   {
>>>   	struct md_cluster_info *cinfo =3D mddev->cluster_info;
>>> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>>   	unlock_comm(cinfo);
>>>   }
>>>
>>> --
>>> 1.8.5.6
>
> --=20
> Goldwyn

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWRQusAAoJEDnsnt1WYoG56z0P/RmFT75gDDncpuumDoj9kZAw
0qlRzXB/HdlmtmsicmORyfVzdMoPWRfoYWvuyainnLMwYC2uuZIecyXvEgmlSjl3
5Htnr4InJQUmiWzJse31EayIRM9IprcqnRD/2QenbiI6q2z6YCstcGmC3jGeup9f
vGlOKN0YD/D7TsK419F74RvhnHjlsril/uEI4OODHeCyi+7/3qPfr2TaEDriHNfl
lqMoM374Gef6q+wfwrSQ1mtEMn1it1ZBXh8MfuO+JphxePIWEBXT8r+tjjRWtnzQ
U9jGDv67LNAZquBu9e6pHsJHep5vQCgtrPC7pxPG4/+L5tiBYLABkXX3EDyL+M7/
vtJBb0sMadnSPKtUbb813Mde5Gpy55tRPXHSakuY/XDoajxQ9Nird3cs136GJhXs
RT3G+xl9gd+9eds3kiuUWwhWTkA24Mp2nJzrpHP8YYB6WyksN3YMDOzC+IiVOGK+
1MWllYC7EJoFScAbPs6CGd8Wah7UujbljZCS/t/SiFjkZ0O3ex0UtqtVO/vDRXOZ
ApMaLRhPiANzOgkrsnb9a5B5ijMIJKOMl1b4wXgG85mmxU/bg+SqVavjwfojAXJq
gsUAlb9bF3nmMIYAiiGxR0Fr3uQQ/y+NKNTN81TuGWRAtQ9XgTtox14Gi2RfCa3l
nYQ/R5OIt7S50YveHEvO
=p9mU
-----END PGP SIGNATURE-----
--=-=-=--
