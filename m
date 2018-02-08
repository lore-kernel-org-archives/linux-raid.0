From: Xiao Ni <xni@redhat.com>
Subject: Re: [MDADM PATCH] A sanity check for missing device
Date: Thu, 8 Feb 2018 02:20:16 -0500 (EST)
Message-ID: <878020727.1507060.1518074416349.JavaMail.zimbra@redhat.com>
References: <1517543858-6937-1-git-send-email-xni@redhat.com> <958b9892-1b64-03f7-e47e-0d4f9de36c31@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <958b9892-1b64-03f7-e47e-0d4f9de36c31@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Jes Sorensen" <jes.sorensen@gmail.com>
> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
> Sent: Thursday, February 8, 2018 3:53:15 AM
> Subject: Re: [MDADM PATCH] A sanity check for missing device
> 
> On 02/01/2018 10:57 PM, Xiao Ni wrote:
> > If we don't check the number of missing devices and create raid device
> > with all missing devices, it gives the error message:
> > [root@storageqe-15 mdadm]# ./test --tests=00raid1
> > Testing on linux-3.10.0-830.el7.x86_64 kernel
> > tests/00raid1...
> > ERROR: dmesg prints errors when testing 00raid1!
> > 
> > FAILED - see /var/tmp/00raid1.log and /var/tmp/fail00raid1.log for details
> > 
> > After checking the missing devices number, the test case can pass. And it
> > gives a error log in log file:
> > ++ /root/mdadm/mdadm --quiet -CR /dev/md0 -l 1 -n2 missing missing
> > --auto=yes
> > ++ rv=1
> > ++ case  in
> > ++ cat /var/tmp/stderr
> > mdadm: Subdevs can't be all missing
> > 
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  tests/00raid1 | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tests/00raid1 b/tests/00raid1
> > index c93465d..752bbbf 100644
> > --- a/tests/00raid1
> > +++ b/tests/00raid1
> > @@ -3,6 +3,9 @@
> >  # test version0, version1, and no super
> >  # test resync and recovery.
> >  
> > +# It's just a sanity check. This command shouldn't run successfully
> > +mdadm -CR $md0 -l 1 -n2 missing missing
> > +
> >  mdadm -CR $md0 -l 1 -n2 $dev0 $dev1
> >  check resync
> >  check raid1
> 
> I think we need to test the opposite here - the test shouldn't report an
> error in the log, but rather success if this sanity test passes.

Hi Jes

Is it ok like this:

diff --git a/tests/00raid1 b/tests/00raid1
index c93465d..f6b8be1 100644
--- a/tests/00raid1
+++ b/tests/00raid1
@@ -3,6 +3,10 @@
 # test version0, version1, and no super
 # test resync and recovery.
 
+# It's just a sanity check. This command shouldn't run successfully
+mdadm -CR $md0 -l 1 -n2 missing missing
+check opposite_result
+
 mdadm -CR $md0 -l 1 -n2 $dev0 $dev1
 check resync
 check raid1
diff --git a/tests/func.sh b/tests/func.sh
index 40c6026..af08b60 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -219,6 +219,10 @@ do_setup() {
 # check various things
 check() {
        case $1 in
+       opposite_result )
+               if [ $? -eq 0 ]; then
+                       die "This command shouldn't run successfully"
+               fi
        spares )
                spares=$(tr '] ' '\012\012' < /proc/mdstat | grep -c '(S)' || exit 0)
                [ $spares -ne $2 ] &&

Regards
Xiao

> 
> Cheers,
> Jes
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
