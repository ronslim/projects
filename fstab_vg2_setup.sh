echo "Setting up fstab in progress"
# delete lines containing vg2 as we will re-setup all vg2 logical volume into baseline standard
sed -i '/vg2/d' /etc/fstab
sed -i '/log/d' /etc/fstab
sed -i '/backup/d' /etc/fstab
#echo "LABEL=appdir /appdir ext4 rw,seclabel,relatime, data=ordered 0 0" >> /etc/fstab
#echo "LABEL=varlog /var/log ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=backup /backup ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=inbox /var/spool/inbox ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=outbox /var/spool/outbox ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=extract /var/extract ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=report /var/report ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=archive /archive ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=dynatrace /opt/dynatrace ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
#echo "LABEL=swap /swap ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab*/

echo "LABEL=appdir /appdir ext4 rw,seclabel,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=varlog /var/log ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=backup /backup ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=inbox /var/spool/inbox ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=outbox /var/spool/outbox ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=extract /var/extract ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=report /var/report ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=archive /archive ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab
echo "LABEL=dynatrace /opt/dynatrace ext4 rw,relatime,data=ordered 0 0" >> /etc/fstab

echo "Done setting up fstab"