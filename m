From: Yi Zhang <yizhan@redhat.com>
Subject: Change "mv $targetdir/log $logdir/$log" to "cp $targetdir/log
 $logdir/$log"
Date: Sun, 6 Sep 2015 23:28:27 -0400 (EDT)
Message-ID: <1023141143.22094768.1441596507637.JavaMail.zimbra@redhat.com>
References: <2004794274.22089532.1441594962520.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2004794274.22089532.1441594962520.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neil@brown.name
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil
When I execute mdadm test with --save-logs set, found below error, coul=
d you help check it?

Error log:
tests/10ddf-fail-readd... FAILED - see /var/tmp/log-10ddf-fail-readd fo=
r details
cp: cannot stat =E2=80=98/var/tmp/log=E2=80=99: No such file or directo=
ry

Code:
    if ( set -ex ; . $_script ) &> $targetdir/log
    then
      echo "succeeded"
      _fail=3D0
    else
      log=3Dlog
      cat $targetdir/stderr >> $targetdir/log
      echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3Ddmesg=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D" >> $=
targetdir/log
      dmesg | tail -n 200 >> $targetdir/log
      if [ $exitonerror =3D=3D 0 ]; then
          log=3Dlog-`basename $_script`
          mv $targetdir/log $logdir/$log                           // T=
his step will move $targetdir/log to $logdir/$log,
      fi
      echo "FAILED - see $logdir/$log for details"
      _fail=3D1
    fi
    if [ "$savelogs" =3D=3D "1" ]; then
      cp $targetdir/log $logdir/$_basename.log                     // I=
f I set $savelogs here, the $targetdir/log doesn't exist now
    fi

So could we change the mv to cp?
diff --git a/test b/test
index d0a6cb8..118fa96 100755
--- a/test
+++ b/test
@@ -318,7 +318,7 @@ do_test() {
       dmesg | tail -n 200 >> $targetdir/log
       if [ $exitonerror =3D=3D 0 ]; then
          log=3Dlog-`basename $_script`
-         mv $targetdir/log $logdir/$log
+         cp $targetdir/log $logdir/$log
       fi
       echo "FAILED - see $logdir/$log for details"
       _fail=3D1

Best Regards,
  Yi Zhang


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
